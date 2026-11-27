<?php

namespace Database\Seeders;

use App\Models\Bookshelf;
use Illuminate\Database\Seeder;

class BookshelfSeeder extends Seeder
{
    public function run(): void
    {
        $shelves = [
            ['name' => 'Sastra', 'description' => 'Koleksi buku-buku sastra klasik dunia'],
            ['name' => 'Sejarah', 'description' => 'Koleksi buku-buku catatan sejarah masa lalu'],
            ['name' => 'Filsafat', 'description' => 'Koleksi pemikiran dan filsafat klasik'],
        ];

        foreach ($shelves as $shelf) {
            Bookshelf::firstOrCreate(
                ['name' => $shelf['name'], 'user_id' => null],
                ['description' => $shelf['description']],
            );
        }
    }
}
