import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';

Future<void> submitReview(String idUser, int idWorker, int rating, String comment) async {
  // Define the URL for the PHP script
  final String url = '$apiBaseUrl/halotec/review_worker/create.php'; // Replace with your actual URL

  // Create the JSON data to send
  final Map<String, dynamic> reviewData = {
    'id_user': idUser,
    'id_worker': idWorker,
    'rating': rating,
    'comment': comment, // Comment can be null or empty, handle as needed
  };

  // Make the POST request
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reviewData),  // Encode the data to JSON
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        // Review submitted successfully
        print('Review added successfully');
      } else {
        // Failed to add review
        print('Failed to add review: ${responseData['message']}');
      }
    } else {
      print('Failed to send request: ${response.statusCode}');
    }
  } catch (e) {
    // Handle error
    print('Error occurred: $e');
  }
}
