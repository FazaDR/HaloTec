import 'package:halotec/util/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response?> ajukan(
    String idUser, int idWorker, String description, String scheduledDate) async {
  final url = Uri.parse('$apiBaseUrl/halotec/pemesanan/create.php'); // Adjust the API endpoint

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_user": idUser, // String
        "id_worker": idWorker, // int
        "description": description,
        "scheduled_date": scheduledDate,
      }),
    );

    if (response.statusCode == 200) {
      return response; // Successful request
    } else {
      print('Error: ${response.body}');
      return null; // Other errors
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
