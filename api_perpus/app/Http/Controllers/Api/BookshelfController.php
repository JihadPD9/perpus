<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Bookshelf;
use Illuminate\Http\Request;

class BookshelfController extends Controller
{
    public function index()
    {
        $bookshelves = Bookshelf::with('readingLists')->get();
        return response()->json([
            'success' => true,
            'message' => 'List Data Rak Buku',
            'data'    => $bookshelves
        ], 200);
    }

    public function show($id)
    {
        $bookshelf = Bookshelf::with('readingLists')->find($id);
        if (!$bookshelf) {
            return response()->json([
                'success' => false,
                'message' => 'Rak Buku tidak ditemukan'
            ], 404);
        }
        return response()->json([
            'success' => true,
            'message' => 'Detail Rak Buku',
            'data'    => $bookshelf
        ], 200);
    }
}