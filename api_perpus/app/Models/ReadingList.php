<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReadingList extends Model
{
    use HasFactory;

    protected $fillable = [
        'bookshelf_id',
        'user_id',
        'title',
        'author',
        'cover',
        'last_page',
    ];

    // Relasi Belongs-To ke Bookshelf
    public function bookshelf()
    {
        return $this->belongsTo(Bookshelf::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
