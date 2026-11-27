import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perpus_klassiku/models/collection_item_model.dart';
import 'package:perpus_klassiku/screens/collection_item_detail_page.dart';

void main() {
  testWidgets('collection item details show its reading progress', (
    tester,
  ) async {
    const item = CollectionItemModel(
      id: 1,
      categoryId: 2,
      title: 'Bumi Manusia',
      author: 'Pramoedya Ananta Toer',
      cover: '',
      lastPage: 42,
      categoryName: 'Novel',
    );

    await tester.pumpWidget(
      const MaterialApp(home: CollectionItemDetailPage(item: item)),
    );

    expect(find.text('Bumi Manusia'), findsOneWidget);
    expect(find.text('Pramoedya Ananta Toer'), findsOneWidget);
    expect(find.text('Novel'), findsOneWidget);
    expect(find.text('Halaman terakhir dibaca'), findsOneWidget);
    expect(find.text('Halaman 42'), findsOneWidget);
  });
}
