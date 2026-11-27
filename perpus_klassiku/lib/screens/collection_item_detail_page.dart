import 'package:flutter/material.dart';

import '../models/collection_item_model.dart';
import '../widgets/cover_image.dart';

class CollectionItemDetailPage extends StatelessWidget {
  const CollectionItemDetailPage({super.key, required this.item});

  final CollectionItemModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Item Koleksi')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CoverImage(
              url: item.cover,
              width: 180,
              height: 220,
              iconSize: 100,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _DetailRow(label: 'Penulis', value: item.author),
          const SizedBox(height: 16),
          _DetailRow(label: 'Kategori', value: item.categoryName),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: const Text('Halaman terakhir dibaca'),
              subtitle: Text(
                item.lastPage == 0
                    ? 'Belum mulai membaca'
                    : 'Halaman ${item.lastPage}',
              ),
            ),
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
