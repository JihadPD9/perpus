class CollectionItemModel {
  const CollectionItemModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.author,
    required this.cover,
    required this.lastPage,
    this.categoryName = '',
  });

  final int id;
  final int categoryId;
  final String title;
  final String author;
  final String cover;
  final int lastPage;
  final String categoryName;

  factory CollectionItemModel.fromJson(Map<String, dynamic> json) {
    final category = json['bookshelf'] as Map<String, dynamic>?;

    return CollectionItemModel(
      id: json['id'] as int,
      categoryId: json['bookshelf_id'] as int,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      lastPage: json['last_page'] as int? ?? 0,
      categoryName: category?['name'] as String? ?? '',
    );
  }
}
