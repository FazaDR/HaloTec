import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String tukangName;
  final String phoneNumber;
  final String experience;
  final String minPrice;
  final String maxPrice;
  final String description;

  const EditProfilePage({
    super.key,
    required this.tukangName,
    required this.phoneNumber,
    required this.experience,
    required this.minPrice,
    required this.maxPrice,
    required this.description,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    minPriceController = TextEditingController(text: widget.minPrice);
    maxPriceController = TextEditingController(text: widget.maxPrice);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: const Color(0xFFFFB74D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: minPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Harga Minimum"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Harga Maksimum"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simpan dan kembali ke profil
                Navigator.pop(context);
              },
              child: const Text("Simpan dan Bayar"),
            ),
          ],
        ),
      ),
    );
  }
}
