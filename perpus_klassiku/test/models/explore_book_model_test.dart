import 'package:flutter_test/flutter_test.dart';
import 'package:perpus_klassiku/models/explore_book_model.dart';

void main() {
  test('parses Gutendex book fields used by list and detail pages', () {
    final book = ExploreBookModel.fromJson({
      'title': 'A Classic',
      'authors': [
        {'name': 'A. Writer'},
        {'name': 'B. Writer'},
      ],
      'formats': {'image/jpeg': 'https://example.test/cover.jpg'},
      'languages': ['en', 'fr'],
      'download_count': 1234,
      'subjects': ['History', 'Fiction'],
    });

    expect(book.author, 'A. Writer');
    expect(book.imageUrl, 'https://example.test/cover.jpg');
    expect(book.languages, ['en', 'fr']);
    expect(book.downloadCount, 1234);
    expect(book.subjects, ['History', 'Fiction']);
  });

  test('uses safe defaults when optional Gutendex fields are absent', () {
    final book = ExploreBookModel.fromJson({'title': 'A Classic'});

    expect(book.author, 'Penulis tidak diketahui');
    expect(book.imageUrl, isEmpty);
    expect(book.languages, isEmpty);
    expect(book.downloadCount, 0);
    expect(book.subjects, isEmpty);
  });
}
