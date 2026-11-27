<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bookshelf extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'description', 'user_id'];

    // Relasi One-to-Many ke ReadingList
    public function readingLists()
    {
        return $this->hasMany(ReadingList::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
