<?php

namespace Tests\Feature;

use App\Models\Bookshelf;
use App\Models\User;
use Database\Seeders\BookSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BookCatalogTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_load_the_local_book_catalog(): void
    {
        $this->seed(BookSeeder::class);

        $token = User::factory()->create()
            ->createToken('catalog-test')
            ->plainTextToken;

        $this->withToken($token)
            ->getJson('/api/books')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(6, 'data')
            ->assertJsonFragment([
                'title' => 'Frankenstein',
                'author' => 'Mary Shelley',
                'cover' => null,
            ]);
    }

    public function test_book_without_a_cover_can_be_saved_to_a_bookshelf(): void
    {
        $bookshelf = Bookshelf::create(['name' => 'Novel']);
        $token = User::factory()->create()
            ->createToken('reading-list-test')
            ->plainTextToken;

        $this->withToken($token)
            ->postJson('/api/reading-lists', [
                'bookshelf_id' => $bookshelf->id,
                'title' => 'Frankenstein',
                'author' => 'Mary Shelley',
            ])
            ->assertCreated()
            ->assertJsonPath('data.cover', '');

        $this->assertDatabaseHas('reading_lists', [
            'bookshelf_id' => $bookshelf->id,
            'title' => 'Frankenstein',
            'cover' => '',
        ]);
    }
}
