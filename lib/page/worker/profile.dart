import 'dart:io'; // For file handling
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:halotec/util/SharedPreferences.dart';
import 'package:halotec/db/db_portofolio.dart';
import 'package:halotec/util/config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<Portfolio> portfolioList = [];
  final TextEditingController _descriptionController = TextEditingController();
  String? workerId='';
  String? tukangName = '';
  String? username = '';
  String? phoneNumber = '';
  String? experience = '';
  String? priceRange = '';
  String? description = '';
  String? skills; // Store skills as a string for now
  String? imageUrl = '';
  String? finalimageUrl='';

  List<String> selectedSkills = [];
  List<File> portfolioImages = [];

  @override
  void initState() {
    super.initState();
    _loadWorkerData();
  }

Future<void> _loadWorkerData() async {
  final workerData = await SharedPreferencesHelper.getWorkerData();

  setState(() {
    workerId =workerData['id_worker'] ?? '';
    tukangName = workerData['nama'] ?? '';
    username = workerData['username'] ?? ''; // Assuming 'id_worker' as username
    phoneNumber = workerData['telpon'] ?? '';
    experience = workerData['pengalaman_kerja'] ?? '';
    priceRange = workerData['range_harga'] ?? '';
    description = workerData['deskripsi'] ?? ''; // Assuming deskripsi for description
    if (workerData['keahlian'] != null) {
      selectedSkills = workerData['keahlian']!.split(','); // Split skills (keahlian) based on commas
    }
    imageUrl = workerData['profile_pic'] ?? '';
    finalimageUrl='$apiBaseUrl${imageUrl}';

    
      print(tukangName);
      print(username);
      print(phoneNumber);
      print(experience);
      print(priceRange);
      print(description);
      print(selectedSkills);
      print(imageUrl);
  });


}


Future<void> _fetchWorkerPortfolio(int workerIdInt) async {
  print('Fetching portfolio for worker with ID: $workerIdInt'); // Debugging: Show the worker ID
  final portfolios = await fetchPortfolio(workerIdInt);
  
  if (portfolios != null) {
    print('Portfolios fetched: $portfolios'); // Debugging: Show the fetched portfolios
    setState(() {
      // Assuming each portfolio image has an 'image' property that's just the image filename
      portfolioList = portfolios.map((portfolio) {
        // Prepending the base URL to the image path
        portfolio.imageUrl = '$apiBaseUrl${portfolio.imageUrl}';
        print(portfolio.imageUrl);
        return portfolio;
      }).toList();
    });
  } else {
    print('No portfolios found for worker with ID: $workerIdInt'); // Debugging: No portfolios found
  }
}

  // void _saveProfile() {
  //   print('Deskripsi: ${_descriptionController.text}');
  //   print('Keahlian: $selectedSkills');
  //   print('Portofolio: ${portfolioImages.length} gambar');

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Profil Disimpan'),
  //         content: const Text('Perubahan pada profil Anda berhasil disimpan.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

Widget _buildDescriptionSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Deskripsi :",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        // Container with fixed height and white background
        Container(
          width: double.infinity,  // Ensure the container takes the full width
          height: 150, // Set a fixed height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0), // Medium rounded corners
          ),
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,  // Ensure text is left-aligned
              child: Text(
                description ?? '',  // Display description text
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildExperienceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengalaman Kerja',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          Text(
            experience ?? '', // Display work experience
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kisaran Harga',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          Text(
            priceRange ?? '', // Display price range
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

 Widget _buildSkillsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Keahlian',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
        const SizedBox(height: 8),
        Wrap(
          children: selectedSkills.map((skill) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical:2),
              child: Chip(
                label: Text(skill,
                  style: TextStyle(
                    fontSize: 14,  color: Colors.white
                  )
                ),
                backgroundColor: const Color.fromARGB(255, 206, 79, 0),
                side: BorderSide.none,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}



Widget _buildPortfolioSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Portofolio',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
        const SizedBox(height: 8),
        portfolioList.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns in the grid
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: portfolioList.length,
                itemBuilder: (context, index) {
                  final portfolio = portfolioList[index];
                  return GestureDetector(
                    onTap: () {
                      // Optional: Add logic to view full image or details
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage('$apiBaseUrl${portfolio.imageUrl}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'Belum ada portofolio yang ditambahkan.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    ),
  );
}


  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 173, 50),
                Color.fromARGB(255, 255, 173, 50),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(211, 252, 249, 221),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(50.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: MediaQuery.of(context).size.width / 2 - 55,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: finalimageUrl != null && finalimageUrl!.isNotEmpty
                                ? NetworkImage(finalimageUrl!) // If finalimageUrl is a URL
                                : null, // Use FileImage or fallback for file paths
                            child: finalimageUrl == null || finalimageUrl!.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 50.0,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tukangName ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Nama Pengguna', username ?? ''),
                    _buildInfoRow('Nomor Telepon', phoneNumber ?? ''),
                    _buildExperienceSection(),
                    _buildPriceRangeSection(),
                    _buildSkillsSection(),
                    _buildDescriptionSection(),
                    _buildPortfolioSection(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,  // Align the button to the right
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Add the debug statement to print the workerId
                            print('Worker ID: $workerId');
                            // Call the save profile function
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Edit Profil'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
