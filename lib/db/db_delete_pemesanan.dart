import 'package:halotec/util/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> deleteService(int idPemesanan, Function onDelete) async {
  // Define the API endpoint URL
  final String url = '$apiBaseUrl/halotec/pemesanan/delete.php'; // Replace with your actual server URL
  
  // Prepare the JSON data
  final Map<String, dynamic> requestData = {
    'id_pemesanan': idPemesanan,
  };

  try {
    // Send the DELETE request with JSON body
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Optionally include an authorization token if required
      },
      body: json.encode(requestData),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      if (responseData['status'] == 'success') {
        print('Order deleted successfully');
        onDelete(); // Notify the UI to update the list
      } else {
        print('Error deleting order: ${responseData['message']}');
      }
    } else {
      print('Failed to delete order. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
