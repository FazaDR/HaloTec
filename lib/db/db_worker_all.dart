import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';

class Worker {
  final int idWorker;
  final String nama;
  final String telpon;
  final int pengalamanKerja;
  final String rangeHarga;
  final String deskripsi;
  final String paymentPlan;
  final String profilePic;
  final int kategoriId; // Changed to int for consistency with JSON
  final String kategoriName; // New field for mapped category name
  final String keahlian;
  final double rating;

  Worker({
    required this.idWorker,
    required this.nama,
    required this.telpon,
    required this.pengalamanKerja,
    required this.rangeHarga,
    required this.deskripsi,
    required this.paymentPlan,
    required this.profilePic,
    required this.kategoriId,
    required this.kategoriName,
    required this.keahlian,
    required this.rating,
  });

  // A static map of kategori IDs to names (from define_kategori table)
  static const Map<int, String> kategoriMap = {
    1: 'Tukang Kayu',
    2: 'Tukang Atap',
    3: 'Tukang Mason',
    4: 'Tukang Listrik',
    5: 'Pekerjaan Pipa',
    6: 'Tukang Interior',
    7: 'Teknisi Mekanik',
    8: 'Teknisi Elektronika',
    9: 'Teknisi AC',
    10: 'Teknisi Digital',
    11: 'Teknisi CCTV',
  };

  factory Worker.fromJson(Map<String, dynamic> json) {
    int kategoriId = json['kategori'] ?? 0;
    String profilePic = json['profile_pic'] ?? '';
    if (profilePic.isNotEmpty && !profilePic.startsWith('http')) {
      profilePic = '$apiBaseUrl$profilePic'; // Use the apiBaseUrl for the profile picture
    }

    return Worker(
      idWorker: json['id_worker'],
      nama: json['nama'],
      telpon: json['telpon'] ?? 'N/A',
      pengalamanKerja: json['pengalaman_kerja'] ?? 'No experience provided',
      rangeHarga: json['range_harga'] ?? 'Not specified',
      deskripsi: json['deskripsi'] ?? 'No description provided',
      paymentPlan: json['payment_plan'] ?? 'Not specified',
      profilePic: profilePic,
      kategoriId: kategoriId,
      kategoriName: kategoriMap[kategoriId] ?? 'Unknown', // Map kategori ID to name
      keahlian: json['keahlian'] ?? 'No skills provided',
      rating: double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0.0,
    );
  }
}


Future<List<Worker>> fetchWorkers({
  String? kategori,
  String? pengalamanKerja,
  String? keahlian,
  String? deskripsi,
  double? ratingFilter,
  double? hargaFilter, // New filter for harga
}) async {
  // API Endpoint
  final url = Uri.parse("$apiBaseUrl/halotec/worker_data/fetch_filter.php");

  // Query parameters
  final queryParams = {
    if (kategori != null && kategori.isNotEmpty) 'kategori': kategori,
    if (pengalamanKerja != null && pengalamanKerja.isNotEmpty) 'pengalaman_kerja': pengalamanKerja,
    if (keahlian != null && keahlian.isNotEmpty) 'keahlian': keahlian,
    if (deskripsi != null && deskripsi.isNotEmpty) 'deskripsi': deskripsi,
    if (ratingFilter != null) 'rating_filter': ratingFilter.toString(),
    if (hargaFilter != null) 'harga_filter': hargaFilter.toString(), // Pass harga filter
  };

  // Add query parameters to URL
  final uriWithParams = url.replace(queryParameters: queryParams);

  // Make GET request
  final response = await http.get(uriWithParams);

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'success') {
      // Parse workers list
      List workers = jsonData['workers'];
      return workers.map((data) => Worker.fromJson(data)).toList();
    } else {
      throw Exception(jsonData['message']);
    }
  } else {
    throw Exception('Failed to load workers');
  }
}
