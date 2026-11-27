<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookController;
use App\Http\Controllers\Api\BookshelfController;
use App\Http\Controllers\Api\ReadingListController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Public Routes (Bisa diakses tanpa login)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected Routes (Hanya bisa diakses jika sudah login / membawa token Sanctum)
Route::middleware('auth:sanctum')->group(function () {
    // Auth & User Profile
    Route::get('/user', function (Request $request) {
        return response()->json([
            'success' => true,
            'data' => $request->user(),
        ]);
    });
    Route::post('/logout', [AuthController::class, 'logout']);

    // Katalog buku lokal
    Route::get('/books', [BookController::class, 'index']);

    // Kategori (menggunakan tabel bookshelves)
    Route::apiResource('categories', BookshelfController::class);

    // Rute lama tetap didukung untuk klien yang sudah ada.
    Route::get('/bookshelves', [BookshelfController::class, 'index']);
    Route::get('/bookshelves/{id}', [BookshelfController::class, 'show']);

    // Item koleksi (menggunakan tabel reading_lists)
    Route::get('/collection-items', [ReadingListController::class, 'index']);
    Route::post('/collection-items', [ReadingListController::class, 'store']);
    Route::put('/collection-items/{id}', [ReadingListController::class, 'update']);
    Route::delete('/collection-items/{id}', [ReadingListController::class, 'destroy']);

    // Rute lama tetap didukung untuk klien yang sudah ada.
    Route::get('/reading-lists', [ReadingListController::class, 'index']);
    Route::post('/reading-lists', [ReadingListController::class, 'store']);
    Route::put('/reading-lists/{id}', [ReadingListController::class, 'update']);
    Route::delete('/reading-lists/{id}', [ReadingListController::class, 'destroy']);
});
