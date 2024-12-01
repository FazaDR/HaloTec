import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';

class Pemesanan {
  final int idPemesanan;
  final String description;
  final String scheduledDate;
  String status;
  final String? cancelReason;
  final String createdAt;
  final String userNama;
  final String userTelpon; // WhatsApp link for the user
  final String userAlamat;
  final String userProfilePic;
  final String userGender;
  final String workerNama;
  final String workerTelpon; // WhatsApp link for the worker
  final String workerProfilePic;
  final String workerKategori;
  final int idWorker; // Added field for worker ID

  Pemesanan({
    required this.idPemesanan,
    required this.description,
    required this.scheduledDate,
    required this.status,
    this.cancelReason,
    required this.createdAt,
    required this.userNama,
    required this.userTelpon,
    required this.userAlamat,
    required this.userProfilePic,
    required this.userGender,
    required this.workerNama,
    required this.workerTelpon,
    required this.workerProfilePic,
    required this.workerKategori,
    required this.idWorker, // Added constructor parameter
  });

  // Factory method to create an instance from JSON
  factory Pemesanan.fromJson(Map<String, dynamic> json) {
    // Modify the phone number to replace '0' with '+62'
    String generateWhatsAppLink(String phoneNumber) {
      // Check if the phone number starts with '0' and replace it with '+62'
      if (phoneNumber.startsWith('0')) {
        phoneNumber = '+62' + phoneNumber.substring(1);
      }
      return "https://wa.me/$phoneNumber";
    }

    return Pemesanan(
      idPemesanan: json['id_pemesanan'],
      description: json['description'],
      scheduledDate: json['scheduled_date'],
      status: json['status'],
      cancelReason: json['cancel_reason'],
      createdAt: json['created_at'],
      userNama: json['user_nama'],
      userTelpon: generateWhatsAppLink(json['user_telpon']), // Generate WhatsApp link
      userAlamat: json['user_alamat'],
      userProfilePic: apiBaseUrl + json['user_profile_pic'],
      userGender: json['user_gender'],
      workerNama: json['worker_nama'],
      workerTelpon: generateWhatsAppLink(json['worker_telpon']), // Generate WhatsApp link
      workerProfilePic: apiBaseUrl + json['worker_profile_pic'],
      workerKategori: json['worker_kategori'],
      idWorker: json['id_worker'], // Add the worker ID
    );
  }

  // Function to fetch the data from the API
  static Future<List<Pemesanan>> fetchPemesananData(String id, bool isUserId) async {
    final String apiUrl = '$apiBaseUrl/halotec/pemesanan/modul.php';

    try {
      // Prepare the request body based on the flag
      Map<String, dynamic> requestBody = {};

      if (isUserId) {
        requestBody['id_user'] = id;
      } else {
        requestBody['id_worker'] = id;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Parse the list of Pemesanan from the response
          return (data['data'] as List)
              .map((item) => Pemesanan.fromJson(item))
              .toList();
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
