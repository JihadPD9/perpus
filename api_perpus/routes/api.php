<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookController;
use App\Http\Controllers\Api\BookshelfController;
use App\Http\Controllers\Api\ReadingListController;

// Public Routes (Bisa diakses tanpa login)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected Routes (Hanya bisa diakses jika sudah login / membawa token Sanctum)
Route::middleware('auth:sanctum')->group(function () {
    // Auth & User Profile
    Route::get('/user', function (Request $request) {
        return response()->json([
            'success' => true,
            'data' => $request->user()
        ]);
    });
    Route::post('/logout', [AuthController::class, 'logout']);

    // Katalog buku lokal
    Route::get('/books', [BookController::class, 'index']);

    // Rak Buku (Bookshelves) - Induk
    Route::get('/bookshelves', [BookshelfController::class, 'index']);
    Route::get('/bookshelves/{id}', [BookshelfController::class, 'show']);

    // Daftar Bacaan (Reading Lists) - Anak
    Route::get('/reading-lists', [ReadingListController::class, 'index']);
    Route::post('/reading-lists', [ReadingListController::class, 'store']);
    Route::put('/reading-lists/{id}', [ReadingListController::class, 'update']);
    Route::delete('/reading-lists/{id}', [ReadingListController::class, 'destroy']);
});