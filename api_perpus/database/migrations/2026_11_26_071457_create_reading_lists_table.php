<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('reading_lists', function (Blueprint $table) {
            $table->id();
            $table->foreignId('bookshelf_id')->constrained('bookshelves')->onDelete('cascade');
            $table->string('title');
            $table->string('author');
            $table->text('cover'); // Menyimpan URL gambar (formats['image/jpeg'])
            $table->integer('last_page')->default(0); // Halaman terakhir dibaca
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reading_lists');
    }
};
