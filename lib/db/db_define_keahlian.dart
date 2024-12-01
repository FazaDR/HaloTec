import 'package:halotec/util/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<Map<String, dynamic>>> fetchKeahlian(String kategoriId) async {
  final response = await http.post(
    Uri.parse('$apiBaseUrl/halotec/define/modul_keahlian.php'),
    body: json.encode({'id_kategori': kategoriId}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final jsonResp = json.decode(response.body);
    if (jsonResp['status'] == 'success') {
      return List<Map<String, dynamic>>.from(
        jsonResp['skills'].map((e) => {
          'id_keahlian': e['id_keahlian'],
          'nama_keahlian': e['nama_keahlian'],
        }),
      );
    } else {
      throw Exception(jsonResp['message']);
    }
  } else {
    throw Exception('Failed to fetch skills');
  }
}