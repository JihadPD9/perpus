import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perpus_klassiku/models/explore_book_model.dart';
import 'package:perpus_klassiku/screens/explore/explore_detail_page.dart';

void main() {
  testWidgets(
    'detail page displays Gutendex language, downloads, and subjects',
    (tester) async {
      final book = ExploreBookModel.fromJson({
        'title': 'A Classic',
        'authors': [
          {'name': 'A. Writer'},
        ],
        'languages': ['en', 'id'],
        'download_count': 1234,
        'subjects': ['History', 'Fiction'],
      });

      await tester.pumpWidget(MaterialApp(home: ExploreDetailPage(book: book)));

      expect(find.text('Bahasa'), findsOneWidget);
      expect(find.text('en, id'), findsOneWidget);
      expect(find.text('Jumlah unduhan'), findsOneWidget);
      expect(find.text('1234'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Fiction'), findsOneWidget);
    },
  );
}
