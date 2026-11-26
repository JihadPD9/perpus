class Bookshelf {
  final int id;
  final String name;
  final String? description;
  List<ReadingList> readingLists;

  Bookshelf({
    required this.id,
    required this.name,
    this.description,
    required this.readingLists,
  });

  factory Bookshelf.fromJson(Map<String, dynamic> json) {
    var list = json['reading_lists'] as List? ?? [];
    List<ReadingList> rLists = list.map((i) => ReadingList.fromJson(i)).toList();

    return Bookshelf(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      readingLists: rLists,
    );
  }
}

class ReadingList {
  final int id;
  final int bookshelfId;
  final String title;
  final String author;
  final String cover;
  int lastPage;

  ReadingList({
    required this.id,
    required this.bookshelfId,
    required this.title,
    required this.author,
    required this.cover,
    required this.lastPage,
  });

  factory ReadingList.fromJson(Map<String, dynamic> json) {
    return ReadingList(
      id: json['id'],
      bookshelfId: json['bookshelf_id'],
      title: json['title'],
      author: json['author'],
      cover: json['cover'],
      lastPage: json['last_page'] ?? 0,
    );
  }
}