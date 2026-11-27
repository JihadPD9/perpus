class ExploreBookModel {
  const ExploreBookModel({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.languages,
    required this.downloadCount,
    required this.subjects,
  });

  final String title;
  final String author;
  final String imageUrl;
  final List<String> languages;
  final int downloadCount;
  final List<String> subjects;

  factory ExploreBookModel.fromJson(Map<String, dynamic> json) {
    final rawAuthors = json['authors'];
    final firstAuthor = rawAuthors is List && rawAuthors.isNotEmpty
        ? rawAuthors.first
        : null;
    final author = firstAuthor is Map<String, dynamic>
        ? firstAuthor['name'] as String? ?? 'Penulis tidak diketahui'
        : 'Penulis tidak diketahui';
    final rawFormats = json['formats'];
    final rawImageUrl = rawFormats is Map ? rawFormats['image/jpeg'] : null;

    return ExploreBookModel(
      title: json['title'] as String? ?? 'Tanpa judul',
      author: author,
      imageUrl: rawImageUrl is String ? rawImageUrl : '',
      languages: _stringList(json['languages']),
      downloadCount: (json['download_count'] as num?)?.toInt() ?? 0,
      subjects: _stringList(json['subjects']),
    );
  }
}

List<String> _stringList(Object? value) =>
    value is List ? value.whereType<String>().toList() : <String>[];
