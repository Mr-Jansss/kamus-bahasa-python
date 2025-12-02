// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String base = ApiConfig.baseUrl;

  Future<Map<String, String>> _jsonHeader() async {
    return {'Content-Type': 'application/json'};
  }

  Future<Map<String, String>> _authHeader() async {
    final headers = await _jsonHeader();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String path) async {
    final url = Uri.parse('$base$path');
    final res = await http.get(url, headers: await _jsonHeader());
    return _processResponse(res);
  }

  Future<dynamic> post(String path, Map body) async {
    final url = Uri.parse('$base$path');
    final res = await http.post(url,
        headers: await _jsonHeader(), body: jsonEncode(body));
    return _processResponse(res);
  }

  Future<dynamic> postWithAuth(String path, Map body) async {
    final url = Uri.parse('$base$path');
    final res = await http.post(url,
        headers: await _authHeader(), body: jsonEncode(body));
    return _processResponse(res);
  }

  Future<dynamic> putWithAuth(String path, Map body) async {
    final url = Uri.parse('$base$path');
    final res = await http.put(url,
        headers: await _authHeader(), body: jsonEncode(body));
    return _processResponse(res);
  }

  Future<dynamic> deleteWithAuth(String path) async {
    final url = Uri.parse('$base$path');
    final res = await http.delete(url, headers: await _authHeader());
    return _processResponse(res);
  }

  dynamic _processResponse(http.Response res) {
    final code = res.statusCode;
    if (res.body.isEmpty) {
      if (code >= 200 && code < 300) return null;
      throw Exception('Error ${res.statusCode}');
    }
    final parsed = jsonDecode(res.body);
    if (code >= 200 && code < 300) return parsed;
    throw Exception(parsed['error'] ?? parsed.toString());
  }
}
