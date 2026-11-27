import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constant.dart';
import '../models/explore_book_model.dart';
import 'api_exception.dart';

class PublicApiService {
  static Future<List<ExploreBookModel>> fetchBooks() async {
    final uri = Uri.parse(
      '${ApiConstant.publicApiUrl}${ApiConstant.publicBooksPath}',
    );
    final response = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(ApiConstant.publicApiTimeout);
    if (response.statusCode != 200) {
      throw ApiException(
        'Gagal memuat katalog buku Gutendex (${response.statusCode}).',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic> || data['results'] is! List) {
      throw const ApiException('Format katalog buku Gutendex tidak valid.');
    }

    final results = data['results'] as List<dynamic>;
    final selectedBooks = results.take(ApiConstant.publicBooksLimit).toList();
    if (selectedBooks.any((book) => book is! Map<String, dynamic>)) {
      throw const ApiException('Data buku Gutendex tidak valid.');
    }
    return selectedBooks
        .cast<Map<String, dynamic>>()
        .map(ExploreBookModel.fromJson)
        .toList();
  }
}
