import 'package:flutter/material.dart';

import '../../models/explore_book_model.dart';
import '../../routes/app_routing.dart';
import '../../services/public_api_service.dart';
import '../../widgets/cover_image.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<ExploreBookModel>> _books;

  @override
  void initState() {
    super.initState();
    _books = PublicApiService.fetchBooks();
  }

  Future<void> _reload() async {
    final books = PublicApiService.fetchBooks();
    setState(() {
      _books = books;
    });
    try {
      await books;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat buku publik: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExploreBookModel>>(
      future: _books,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal memuat buku publik.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        final books = snapshot.data ?? const <ExploreBookModel>[];
        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: books.isEmpty ? 1 : books.length,
            itemBuilder: (context, index) {
              if (books.isEmpty) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: const Center(
                    child: Text('Belum ada buku yang bisa ditampilkan.'),
                  ),
                );
              }
              final book = books[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CoverImage(
                    url: book.imageUrl,
                    width: 52,
                    height: 72,
                    iconSize: 36,
                  ),
                  title: Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    book.author,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouting.exploreDetail,
                    arguments: book,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
