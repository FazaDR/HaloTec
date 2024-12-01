import 'package:halotec/util/config.dart'; // Ensure you have a valid apiBaseUrl defined here
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> fetchKategori() async {
  final response = await http.get(
    Uri.parse('$apiBaseUrl/halotec/define/modul_kategori.php'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final jsonResp = json.decode(response.body);
    if (jsonResp['status'] == 'success') {
      return List<Map<String, String>>.from(
        jsonResp['categories'].map((e) => {
          'id_kategori': e['id_kategori'].toString(),
          'nama_kategori': e['nama_kategori'].toString(),
          'icon_name': e['icon_name'].toString(),
        }),
      );
    } else {
      throw Exception(jsonResp['message']);
    }
  } else {
    throw Exception('Failed to fetch categories');
  }
}
