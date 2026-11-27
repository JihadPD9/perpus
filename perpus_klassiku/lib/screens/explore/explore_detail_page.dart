import 'package:flutter/material.dart';

import '../../models/explore_book_model.dart';
import '../../widgets/cover_image.dart';

class ExploreDetailPage extends StatelessWidget {
  const ExploreDetailPage({super.key, required this.book});

  final ExploreBookModel book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CoverImage(
              url: book.imageUrl,
              width: 180,
              height: 220,
              iconSize: 100,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            book.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(book.author, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _DetailRow(
            label: 'Bahasa',
            value: book.languages.isEmpty
                ? 'Tidak diketahui'
                : book.languages.join(', '),
          ),
          const SizedBox(height: 16),
          _DetailRow(
            label: 'Jumlah unduhan',
            value: book.downloadCount.toString(),
          ),
          const SizedBox(height: 16),
          Text('Subjek', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (book.subjects.isEmpty)
            const Text('Informasi subjek tidak tersedia.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: book.subjects
                  .map((subject) => Chip(label: Text(subject)))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
