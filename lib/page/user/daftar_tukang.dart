import 'package:flutter/material.dart';

class DaftarTukangPage extends StatelessWidget {
  final String categoryName;

  DaftarTukangPage({required this.categoryName, required List<Map<String, dynamic>> tukangList});

  // Dummy data untuk tukang per kategori
  final Map<String, List<Map<String, dynamic>>> tukangData = {
    "Tukang Listrik": [
      {
        "name": "Teknisi Listrik 1",
        "experience": "5 Tahun",
        "price": "Rp 50.000 - 100.000",
        "rating": 4.8,
      },
      {
        "name": "Teknisi Listrik 2",
        "experience": "7 Tahun",
        "price": "Rp 60.000 - 120.000",
        "rating": 4.9,
      },
      {
        "name": "Teknisi Listrik 3",
        "experience": "3 Tahun",
        "price": "Rp 45.000 - 80.000",
        "rating": 4.5,
      },
    ],
    "Tukang Atap": [
      {
        "name": "Teknisi Atap 1",
        "experience": "6 Tahun",
        "price": "Rp 70.000 - 120.000",
        "rating": 4.6,
      },
      {
        "name": "Teknisi Atap 2",
        "experience": "8 Tahun",
        "price": "Rp 80.000 - 130.000",
        "rating": 4.8,
      },
      {
        "name": "Teknisi Atap 3",
        "experience": "4 Tahun",
        "price": "Rp 60.000 - 110.000",
        "rating": 4.4,
      },
    ],
    "Tukang Batu dan Beton": [
      {
        "name": "Teknisi Beton 1",
        "experience": "10 Tahun",
        "price": "Rp 100.000 - 150.000",
        "rating": 4.9,
      },
      {
        "name": "Teknisi Beton 2",
        "experience": "8 Tahun",
        "price": "Rp 90.000 - 140.000",
        "rating": 4.7,
      },
      {
        "name": "Teknisi Beton 3",
        "experience": "5 Tahun",
        "price": "Rp 70.000 - 110.000",
        "rating": 4.5,
      },
    ],
    "Pekerjaan Pipa": [
      {
        "name": "Teknisi Pipa 1",
        "experience": "8 Tahun",
        "price": "Rp 80.000 - 130.000",
        "rating": 4.9,
      },
      {
        "name": "Teknisi Pipa 2",
        "experience": "5 Tahun",
        "price": "Rp 60.000 - 100.000",
        "rating": 4.6,
      },
      {
        "name": "Teknisi Pipa 3",
        "experience": "6 Tahun",
        "price": "Rp 70.000 - 120.000",
        "rating": 4.7,
      },
    ],
    "Teknisi Mekanik": [
      {
        "name": "Teknisi Mekanik 1",
        "experience": "4 Tahun",
        "price": "Rp 60.000 - 120.000",
        "rating": 4.7,
      },
      {
        "name": "Teknisi Mekanik 2",
        "experience": "6 Tahun",
        "price": "Rp 80.000 - 140.000",
        "rating": 4.8,
      },
      {
        "name": "Teknisi Mekanik 3",
        "experience": "3 Tahun",
        "price": "Rp 50.000 - 90.000",
        "rating": 4.5,
      },
    ],
    "Teknisi Elektronika": [
      {
        "name": "Teknisi Elektronika 1",
        "experience": "5 Tahun",
        "price": "Rp 70.000 - 110.000",
        "rating": 4.8,
      },
      {
        "name": "Teknisi Elektronika 2",
        "experience": "7 Tahun",
        "price": "Rp 90.000 - 130.000",
        "rating": 4.9,
      },
      {
        "name": "Teknisi Elektronika 3",
        "experience": "4 Tahun",
        "price": "Rp 60.000 - 100.000",
        "rating": 4.6,
      },
    ],
    "Teknisi AC": [
      {
        "name": "Teknisi AC 1",
        "experience": "4 Tahun",
        "price": "Rp 40.000 - 90.000",
        "rating": 4.5,
      },
      {
        "name": "Teknisi AC 2",
        "experience": "6 Tahun",
        "price": "Rp 60.000 - 110.000",
        "rating": 4.7,
      },
      {
        "name": "Teknisi AC 3",
        "experience": "3 Tahun",
        "price": "Rp 50.000 - 80.000",
        "rating": 4.3,
      },
    ],
    "Tukang Digital": [
      {
        "name": "Teknisi Digital 1",
        "experience": "3 Tahun",
        "price": "Rp 50.000 - 90.000",
        "rating": 4.4,
      },
      {
        "name": "Teknisi Digital 2",
        "experience": "5 Tahun",
        "price": "Rp 60.000 - 100.000",
        "rating": 4.6,
      },
      {
        "name": "Teknisi Digital 3",
        "experience": "4 Tahun",
        "price": "Rp 55.000 - 95.000",
        "rating": 4.5,
      },
    ],
    "Teknisi CCTV Dan Keamanan": [
      {
        "name": "Teknisi CCTV 1",
        "experience": "6 Tahun",
        "price": "Rp 70.000 - 120.000",
        "rating": 4.8,
      },
      {
        "name": "Teknisi CCTV 2",
        "experience": "8 Tahun",
        "price": "Rp 80.000 - 130.000",
        "rating": 4.9,
      },
      {
        "name": "Teknisi CCTV 3",
        "experience": "5 Tahun",
        "price": "Rp 60.000 - 110.000",
        "rating": 4.6,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final tukangList = tukangData[categoryName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        itemCount: tukangList.length,
        itemBuilder: (context, index) {
          final tukang = tukangList[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        child: Icon(Icons.person, size: 30.0),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tukang["name"],
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(tukang["experience"]),
                            Text(tukang["price"]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Rating: ${tukang['rating']}",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.star, color: Colors.orange, size: 16.0),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle "Ajukan"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                        ),
                        child: Text("Ajukan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
