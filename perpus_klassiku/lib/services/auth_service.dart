import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constant.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  static Future<bool> hasToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    return token != null && token.isNotEmpty;
  }

  static Future<UserModel> login(String email, String password) async {
    final response = await ApiClient.request(
      'POST',
      ApiConstant.loginPath,
      authenticated: false,
      body: {'email': email, 'password': password},
    ).timeout(ApiConstant.requestTimeout);
    final data = response['data'] as Map<String, dynamic>;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', data['token'] as String);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  static Future<UserModel> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await ApiClient.request(
      'POST',
      ApiConstant.registerPath,
      authenticated: false,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    ).timeout(ApiConstant.requestTimeout);
    final data = response['data'] as Map<String, dynamic>;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', data['token'] as String);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  static Future<UserModel> currentUser() async {
    final response = await ApiClient.request(
      'GET',
      ApiConstant.userPath,
    ).timeout(ApiConstant.requestTimeout);
    return UserModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  static Future<void> logout() async {
    try {
      await ApiClient.request(
        'POST',
        ApiConstant.logoutPath,
      ).timeout(ApiConstant.requestTimeout);
    } finally {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
    }
  }
}
