import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book_model.dart';
import '../models/bookshelf_model.dart';

class ApiService {
  // Gunakan 10.0.2.2 untuk Emulator Android, atau IP lokal laptop jika pakai HP asli
  static const String baseUrl = 'http://10.10.8.157:8000/api';

  // --- 1. AUTHENTICATION ---
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['data']['token']);
    }
    return data;
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['data']['token']);
    }
    return data;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    await prefs.remove('token');
  }

  // --- 2. LARAVEL BOOK CATALOG ---
  static Future<List<Book>> fetchBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/books'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List results = data['data'];
      return results.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat katalog buku (${response.statusCode})');
    }
  }

  // --- 3. LARAVEL BOOKSHELVES & READING LISTS ---
  static Future<List<Bookshelf>> fetchBookshelves() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/bookshelves'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List results = data['data'];
      return results.map((json) => Bookshelf.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data Rak Buku');
    }
  }

  static Future<bool> addToReadingList(Map<String, dynamic> bookData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/reading-lists'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookData),
    );

    return response.statusCode == 201;
  }
}
