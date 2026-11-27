<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Bookshelf;
use App\Models\ReadingList;
use Illuminate\Http\Request;

class ReadingListController extends Controller
{
    public function index(Request $request)
    {
        $items = ReadingList::query()
            ->where('user_id', $request->user()->id)
            ->with('bookshelf')
            ->when($request->filled('category_id'), function ($query) use ($request) {
                $query->where('bookshelf_id', $request->integer('category_id'));
            })
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $items,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'nullable|required_without:bookshelf_id|integer|exists:bookshelves,id',
            'bookshelf_id' => 'nullable|required_without:category_id|integer|exists:bookshelves,id',
            'title' => 'required|string|max:255',
            'author' => 'required|string|max:255',
            'cover' => 'nullable|string',
            'last_page' => 'nullable|integer|min:0',
        ]);

        $categoryId = $validated['category_id'] ?? $validated['bookshelf_id'];
        $this->findVisibleCategory($request, (int) $categoryId);

        $item = ReadingList::create([
            'bookshelf_id' => $categoryId,
            'user_id' => $request->user()->id,
            'title' => $validated['title'],
            'author' => $validated['author'],
            'cover' => $validated['cover'] ?? '',
            'last_page' => $validated['last_page'] ?? 0,
        ]);

        return response()->json([
            'success' => true,
            'data' => $item->load('bookshelf'),
        ], 201);
    }

    public function update(Request $request, int $id)
    {
        $item = ReadingList::query()
            ->where('user_id', $request->user()->id)
            ->findOrFail($id);

        $validated = $request->validate([
            'category_id' => 'sometimes|required|integer|exists:bookshelves,id',
            'bookshelf_id' => 'sometimes|required|integer|exists:bookshelves,id',
            'title' => 'sometimes|required|string|max:255',
            'author' => 'sometimes|required|string|max:255',
            'cover' => 'nullable|string',
            'last_page' => 'sometimes|integer|min:0',
        ]);

        $categoryId = $validated['category_id'] ?? $validated['bookshelf_id'] ?? null;
        if ($categoryId !== null) {
            $this->findVisibleCategory($request, (int) $categoryId);
            $validated['bookshelf_id'] = $categoryId;
        }
        unset($validated['category_id']);
        if (array_key_exists('cover', $validated) && $validated['cover'] === null) {
            $validated['cover'] = '';
        }

        $item->update($validated);

        return response()->json([
            'success' => true,
            'data' => $item->refresh()->load('bookshelf'),
        ]);
    }

    public function destroy(Request $request, int $id)
    {
        $item = ReadingList::query()
            ->where('user_id', $request->user()->id)
            ->findOrFail($id);

        $item->delete();

        return response()->json([
            'success' => true,
            'message' => 'Item koleksi berhasil dihapus.',
        ]);
    }

    private function findVisibleCategory(Request $request, int $categoryId): Bookshelf
    {
        $userId = $request->user()->id;

        return Bookshelf::query()
            ->whereKey($categoryId)
            ->where(function ($query) use ($userId) {
                $query->whereNull('user_id')->orWhere('user_id', $userId);
            })
            ->firstOrFail();
    }
}
