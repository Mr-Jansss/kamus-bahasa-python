import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config/api.dart';

class AuthService {
  /// LOGIN
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    final data = jsonDecode(response.body);

    // Kalau gagal login
    if (response.statusCode != 200) {
      return {"success": false, "message": data["error"] ?? "Login gagal"};
    }

    final token = data["token"];
    if (token == null) {
      return {"success": false, "message": "Token tidak diterima dari server"};
    }

    // 🔥 Decode JWT untuk mendapatkan id & role
    final decoded = JwtDecoder.decode(token);

    // Simpan token ke device
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);

    return {
      "success": true,
      "token": token,
      "id": decoded["id"],
      "role": decoded["role"],
    };
  }

  /// REGISTER
  Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return jsonDecode(response.body);
  }

  /// GET TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// DECODE TOKEN
  Future<Map<String, dynamic>?> decodeToken() async {
    final token = await getToken();
    if (token == null) return null;

    return JwtDecoder.decode(token);
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}
