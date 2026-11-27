import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constant.dart';
import 'api_exception.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
    Map<String, String>? queryParameters,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';

    if (authenticated) {
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      if (token == null || token.isEmpty) {
        throw const ApiException(
          'Sesi login tidak ditemukan. Silakan login kembali.',
        );
      }
      headers['Authorization'] = 'Bearer $token';
    }

    final uri = Uri.parse('${ApiConstant.baseUrlLaravel}$path')
        .replace(queryParameters: queryParameters);
    final encodedBody = body == null ? null : jsonEncode(body);
    final response = switch (method) {
      'GET' => await _client.get(uri, headers: headers),
      'POST' => await _client.post(uri, headers: headers, body: encodedBody),
      'PUT' => await _client.put(uri, headers: headers, body: encodedBody),
      'DELETE' => await _client.delete(uri, headers: headers),
      _ => throw ArgumentError.value(
        method,
        'method',
        'Metode HTTP tidak didukung',
      ),
    };

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Format respons server tidak valid.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['message'] as String? ??
            'Permintaan gagal (${response.statusCode}).',
      );
    }
    return decoded;
  }
}
