import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';

Future<void> updateServiceStatus(int idPemesanan, String status) async {
  final url = '$apiBaseUrl/halotec/pemesanan/update.php';  // Replace with your actual API URL

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',  // Indicate that we are sending JSON
      },
      body: json.encode({
        'id_pemesanan': idPemesanan,
        'status': status,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        print('Service status updated successfully');
      } else {
        print('Error: ${result['message']}');
      }
    } else {
      print('Failed to update service status');
    }
  } catch (e) {
    print('Error: $e');
  }
  final payload = json.encode({
  'id_pemesanan': idPemesanan,
  'status': status,
});
print('Request payload: $payload');
}