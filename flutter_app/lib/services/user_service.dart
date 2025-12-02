// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class UserService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// GET ALL USERS (ADMIN ONLY)
  Future<List> getAllUsers() async {
    final token = await _getToken();
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/users");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["users"];
    } else {
      throw Exception(jsonDecode(res.body)["error"]);
    }
  }

  /// CREATE USER (ADMIN)
  Future<Map> createUser(String username, String password, String role) async {
    final token = await _getToken();
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/create");

    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "role": role,
      }),
    );

    return jsonDecode(res.body);
  }

  /// DELETE USER (ADMIN)
  Future<bool> deleteUser(int id) async {
    final token = await _getToken();
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/delete/$id");

    final res = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) return true;
    throw Exception("Failed to delete user");
  }
}
