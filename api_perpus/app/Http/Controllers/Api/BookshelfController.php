<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Bookshelf;
use Illuminate\Http\Request;

class BookshelfController extends Controller
{
    public function index(Request $request)
    {
        $userId = $request->user()->id;
        $categories = Bookshelf::query()
            ->where(function ($query) use ($userId) {
                $query->whereNull('user_id')->orWhere('user_id', $userId);
            })
            ->withCount(['readingLists' => function ($query) use ($userId) {
                $query->where('user_id', $userId);
            }])
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $category = Bookshelf::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'success' => true,
            'data' => $category,
        ], 201);
    }

    public function show(Request $request, int $id)
    {
        $category = $this->visibleCategories($request)
            ->with(['readingLists' => function ($query) use ($request) {
                $query->where('user_id', $request->user()->id);
            }])
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $category,
        ]);
    }

    public function update(Request $request, int $id)
    {
        $category = Bookshelf::query()
            ->where('user_id', $request->user()->id)
            ->findOrFail($id);

        $category->update($request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]));

        return response()->json([
            'success' => true,
            'data' => $category->refresh(),
        ]);
    }

    public function destroy(Request $request, int $id)
    {
        $category = Bookshelf::query()
            ->where('user_id', $request->user()->id)
            ->findOrFail($id);

        if ($category->readingLists()->where('user_id', $request->user()->id)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Kategori masih digunakan item koleksi.',
            ], 409);
        }

        $category->delete();

        return response()->json([
            'success' => true,
            'message' => 'Kategori berhasil dihapus.',
        ]);
    }

    private function visibleCategories(Request $request)
    {
        $userId = $request->user()->id;

        return Bookshelf::query()->where(function ($query) use ($userId) {
            $query->whereNull('user_id')->orWhere('user_id', $userId);
        });
    }
}
