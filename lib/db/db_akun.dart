import 'package:halotec/util/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response?> login(String username, String password) async {
  final url = Uri.parse('$apiBaseUrl/halotec/login.php'); // Uses the IPv4 address

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return response; // Successful login
    } else if (response.statusCode == 401) {
      return null; // Unauthorized
    } else {
      print('Error: ${response.body}');
      return null; // Other errors
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

