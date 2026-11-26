<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Bookshelf;

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
            Bookshelf::create($shelf);
        }
    }
}