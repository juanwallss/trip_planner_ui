import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "https://bk6tsqfz-3000.usw3.devtunnels.ms";

  static const String token = '';

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data,
      {bool useToken = false}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {
          "Content-Type": "application/json",
          if (useToken) "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data,
      {bool useToken = false}) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {
          "Content-Type": "application/json",
          if (useToken) "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }
}
