<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Book;

class BookController extends Controller
{
    public function index()
    {
        $books = Book::query()
            ->orderBy('category')
            ->orderBy('title')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Katalog buku',
            'data' => $books,
        ]);
    }
}
