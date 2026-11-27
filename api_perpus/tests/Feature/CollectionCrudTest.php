<?php

namespace Tests\Feature;

use App\Models\Bookshelf;
use App\Models\ReadingList;
use App\Models\User;
use Database\Seeders\BookshelfSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Auth;
use Tests\TestCase;

class CollectionCrudTest extends TestCase
{
    use RefreshDatabase;

    public function test_default_categories_are_shared_and_seeding_is_idempotent(): void
    {
        $this->seed(BookshelfSeeder::class);
        $this->seed(BookshelfSeeder::class);

        $this->assertDatabaseCount('bookshelves', 3);
        foreach (['Filsafat', 'Sastra', 'Sejarah'] as $name) {
            $this->assertDatabaseHas('bookshelves', [
                'name' => $name,
                'user_id' => null,
            ]);
        }
    }

    public function test_user_can_manage_categories_but_cannot_manage_another_users_category(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $ownerToken = $owner->createToken('owner')->plainTextToken;
        $otherToken = $otherUser->createToken('other')->plainTextToken;

        $created = $this->withToken($ownerToken)
            ->postJson('/api/categories', [
                'name' => 'Novel',
                'description' => 'Fiksi',
            ])
            ->assertCreated()
            ->assertJsonPath('data.user_id', $owner->id);
        $categoryId = $created->json('data.id');

        Auth::forgetGuards();
        $this->withToken($ownerToken)
            ->getJson('/api/categories')
            ->assertOk()
            ->assertJsonFragment(['id' => $categoryId, 'name' => 'Novel']);

        Auth::forgetGuards();
        $this->withToken($ownerToken)
            ->putJson("/api/categories/{$categoryId}", [
                'name' => 'Novel Klasik',
                'description' => 'Novel klasik',
            ])
            ->assertOk()
            ->assertJsonPath('data.name', 'Novel Klasik');

        Auth::forgetGuards();
        $this->withToken($otherToken)
            ->getJson('/api/categories')
            ->assertOk()
            ->assertJsonMissing(['name' => 'Novel Klasik']);

        Auth::forgetGuards();
        $this->withToken($otherToken)
            ->deleteJson("/api/categories/{$categoryId}")
            ->assertNotFound();

        Auth::forgetGuards();
        $this->withToken($ownerToken)
            ->deleteJson("/api/categories/{$categoryId}")
            ->assertOk();
    }

    public function test_collection_items_are_owned_by_the_authenticated_user_and_support_crud(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();
        $category = Bookshelf::create(['name' => 'Sastra']);
        $ownerToken = $owner->createToken('owner')->plainTextToken;
        $otherToken = $otherUser->createToken('other')->plainTextToken;

        $created = $this->withToken($ownerToken)
            ->postJson('/api/collection-items', [
                'category_id' => $category->id,
                'title' => 'Bumi Manusia',
                'author' => 'Pramoedya Ananta Toer',
            ])
            ->assertCreated()
            ->assertJsonPath('data.title', 'Bumi Manusia')
            ->assertJsonPath('data.user_id', $owner->id);

        $itemId = $created->json('data.id');

        Auth::forgetGuards();
        $this->withToken($otherToken)
            ->getJson('/api/collection-items')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        Auth::forgetGuards();
        $this->withToken($ownerToken)
            ->getJson("/api/collection-items?category_id={$category->id}")
            ->assertOk()
            ->assertJsonCount(1, 'data');

        Auth::forgetGuards();
        $this->withToken($otherToken)
            ->putJson("/api/collection-items/{$itemId}", ['title' => 'Diubah'])
            ->assertNotFound();

        Auth::forgetGuards();
        $this->withToken($ownerToken)
            ->putJson("/api/collection-items/{$itemId}", [
                'category_id' => $category->id,
                'title' => 'Bumi Manusia (Edisi Revisi)',
                'author' => 'Pramoedya Ananta Toer',
                'cover' => '',
            ])
            ->assertOk()
            ->assertJsonPath('data.title', 'Bumi Manusia (Edisi Revisi)');

        Auth::forgetGuards();
        $this->withToken($ownerToken)
            ->deleteJson("/api/collection-items/{$itemId}")
            ->assertOk();

        $this->assertDatabaseMissing('reading_lists', ['id' => $itemId]);
    }

    public function test_category_cannot_be_deleted_while_user_items_use_it(): void
    {
        $user = User::factory()->create();
        $category = Bookshelf::create([
            'name' => 'Dipakai',
            'user_id' => $user->id,
        ]);
        ReadingList::create([
            'bookshelf_id' => $category->id,
            'user_id' => $user->id,
            'title' => 'Contoh',
            'author' => 'Penulis',
            'cover' => '',
        ]);
        $token = $user->createToken('owner')->plainTextToken;

        $this->withToken($token)
            ->deleteJson("/api/categories/{$category->id}")
            ->assertStatus(409);

        $this->assertDatabaseHas('bookshelves', ['id' => $category->id]);
    }
}
