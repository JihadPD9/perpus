<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ReadingList;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReadingListController extends Controller
{
    // Tampilkan semua buku yang disimpan di reading lists
    public function index()
    {
        $readingLists = ReadingList::with('bookshelf')->get();
        return response()->json([
            'success' => true,
            'message' => 'List Reading Lists',
            'data'    => $readingLists
        ], 200);
    }

    // Simpan buku ke reading list (Disimpan ke rak tertentu)
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'bookshelf_id' => 'required|exists:bookshelves,id',
            'title'        => 'required|string',
            'author'       => 'required|string',
            'cover'        => 'nullable|string',
            'last_page'    => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi Gagal',
                'errors'  => $validator->errors()
            ], 422);
        }

        $readingList = ReadingList::create([
            'bookshelf_id' => $request->bookshelf_id,
            'title'        => $request->title,
            'author'       => $request->author,
            'cover'        => $request->input('cover') ?? '',
            'last_page'    => $request->last_page ?? 0,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Buku berhasil ditambahkan ke Reading List',
            'data'    => $readingList
        ], 201);
    }

    // Update halaman terakhir
    public function update(Request $request, $id)
    {
        $readingList = ReadingList::find($id);
        if (!$readingList) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan',
            ], 404);
        }

        $readingList->update([
            'last_page' => $request->last_page ?? $readingList->last_page,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Halaman terakhir berhasil diperbarui',
            'data'    => $readingList
        ], 200);
    }

    // Hapus dari reading list
    public function destroy($id)
    {
        $readingList = ReadingList::find($id);
        if (!$readingList) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan',
            ], 404);
        }

        $readingList->delete();

        return response()->json([
            'success' => true,
            'message' => 'Buku berhasil dihapus dari Reading List',
        ], 200);
    }
}
