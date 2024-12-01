import 'dart:convert';
import 'package:halotec/util/config.dart';
import 'package:http/http.dart' as http;

// Function to fetch worker data based on username
Future<Map<String, dynamic>?> getWorkerData(String username) async {
  try {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/halotec/worker_data/modul.php?username=$username'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['worker_data']; // Return the worker data
      } else {
        print('Error: ${data['message']}');
        return null;
      }
    } else {
      print('Failed to fetch worker data: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching worker data: $e');
    return null;
  }
}
