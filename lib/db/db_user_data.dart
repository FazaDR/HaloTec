import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';

Future<Map<String, dynamic>?> getUserData(String username) async {
  try {
    // Sending the POST request to the API
    final response = await http.post(
      Uri.parse('$apiBaseUrl/halotec/user_data/modul.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username}),
    );

    // Check if the response status is OK
    if (response.statusCode == 200) {
      try {
        // Attempt to decode the JSON response
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && !data.containsKey('error')) {
          return data; // Return user data if valid
        } else {
          // Log specific error from the server response
          print('Error in response: ${data['error'] ?? 'Unknown error'}');
        }
      } catch (jsonError) {
        // Log JSON decoding errors
        print('JSON decoding error: $jsonError');
        print('Response body: ${response.body}');
      }
    } else {
      // Log HTTP errors
      print('Failed to fetch user data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Log general errors
    print('Error fetching user data: $e');
  }

  // Return null in case of any failure
  return null;
}
