import 'dart:convert';
import 'package:halotec/util/config.dart';
import 'package:http/http.dart' as http;

class Portfolio {
  final int idPortfolio;
  final int idWorker;
  final String imageUrl;
  final String? caption;

  Portfolio({
    required this.idPortfolio,
    required this.idWorker,
    required this.imageUrl,
    this.caption,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      idPortfolio: json['id_portofolio'],
      idWorker: json['id_worker'],
      imageUrl: json['image_url'],
      caption: json['caption'],
    );
  }
}

Future<List<Portfolio>?> fetchPortfolio(int idWorker) async {
  final String url = '$apiBaseUrl/halotec/portofolio/modul.php';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id_worker': idWorker}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'success') {
        final List<dynamic> portfoliosJson = data['portfolios'];
        return portfoliosJson.map((json) => Portfolio.fromJson(json)).toList();
      } else {
        // Return null if portfolio fetch fails, don't throw exception
        return null;
      }
    } else {
      return null; // Return null on server connection failure
    }
  } catch (e) {
    return null; // Return null if an error occurs
  }
}
