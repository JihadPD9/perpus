<?php

namespace Database\Seeders;

use App\Models\Book;
use Illuminate\Database\Seeder;

class BookSeeder extends Seeder
{
    public function run(): void
    {
        $books = [
            [
                'title' => 'Don Quixote',
                'author' => 'Miguel de Cervantes',
                'category' => 'Petualangan',
                'description' => 'Perjalanan seorang bangsawan yang berusaha menghidupkan kembali cita-cita kesatria.',
            ],
            [
                'title' => 'Frankenstein',
                'author' => 'Mary Shelley',
                'category' => 'Novel Klasik',
                'description' => 'Kisah Victor Frankenstein dan konsekuensi dari eksperimennya menciptakan kehidupan.',
            ],
            [
                'title' => 'Pride and Prejudice',
                'author' => 'Jane Austen',
                'category' => 'Novel Klasik',
                'description' => 'Kisah keluarga Bennet, hubungan sosial, dan keputusan hidup.',
            ],
            [
                'title' => 'The Adventures of Sherlock Holmes',
                'author' => 'Arthur Conan Doyle',
                'category' => 'Misteri',
                'description' => 'Kumpulan kasus yang dipecahkan oleh detektif Sherlock Holmes bersama Dr. Watson.',
            ],
            [
                'title' => 'The Art of War',
                'author' => 'Sun Tzu',
                'category' => 'Strategi',
                'description' => 'Risalah klasik tentang perencanaan, strategi, dan kepemimpinan.',
            ],
            [
                'title' => 'The Republic',
                'author' => 'Plato',
                'category' => 'Filsafat',
                'description' => 'Dialog filosofis yang membahas keadilan, negara, dan kehidupan ideal.',
            ],
        ];

        foreach ($books as $book) {
            Book::firstOrCreate(
                ['title' => $book['title'], 'author' => $book['author']],
                $book,
            );
        }
    }
}
