class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final String category;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Tanpa Judul',
      author: json['author'] as String? ?? 'Penulis tidak diketahui',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Umum',
      imageUrl: json['cover'] as String? ?? '',
    );
  }
}
