import 'package:flutter/material.dart';
import 'package:halotec/page/user/navbar_user.dart';
import 'daftar_tukang.dart';
import 'pencarian.dart'; // Import halaman pencarian
import 'package:halotec/db/db_define_kategori.dart'; // Import fetchKategori function
import 'package:halotec/page/Auth.dart';
import 'package:halotec/util/SharedPreferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];

  void _logout(BuildContext context) async {
    await SharedPreferencesHelper.clearPreferences();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthPage(), // Navigate to AuthPage after logout
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Use FutureBuilder to load categories dynamically
  Future<void> _fetchCategories() async {
    try {
      // Call the fetchKategori function to fetch the categories from the database
      List<Map<String, dynamic>> categories = await fetchKategori();
      setState(() {
        _categories = categories;
        _filteredCategories = categories;
      });
    } catch (e) {
      // Handle exceptions here if fetchKategori fails
      setState(() {
        _categories = [];
        _filteredCategories = [];
      });
    }
  }

  // Handle the search functionality
  void _searchCategories(String query) {
    final filtered = _categories.where((category) {
      String categoryName = category['nama_kategori']?.toLowerCase() ?? '';
      return categoryName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredCategories = filtered;
    });
  }

  // Mapping of icon names to Flutter Icons
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "carpenter":
        return Icons.build;
      case "roofing":
        return Icons.roofing;
      case "construction":
        return Icons.construction;
      case "electrical_services":
        return Icons.electrical_services;
      case "plumbing":
        return Icons.plumbing;
      case "home_work":
        return Icons.home_work;
      case "settings":
        return Icons.settings;
      case "memory":
        return Icons.memory;
      case "ac_unit":
        return Icons.ac_unit;
      case "computer":
        return Icons.computer;
      case "videocam":
        return Icons.videocam;
      default:
        return Icons.help; // Default icon in case of an unknown name
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E1),
      body: Column(
        children: [
          // Elevated AppBar with SearchBar
          Material(
            elevation: 5.0, // Elevate the AppBar
            shadowColor: Colors.black.withOpacity(0.5),
            child: Container(
              color: const Color(0xFFFFB74D), // AppBar background color
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HaloTec',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.exit_to_app, color: Colors.black),
                        onPressed: () {
                          _logout(context); // Call the logout method
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Search bar
                  SizedBox(
                    height: 50.0, // Reduced height of the search bar
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari kategori....',
                        hintStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey, // Hint text in gray
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20.0, // Smaller search icon
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.grey, // Outline color
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.brown, // Outline color when focused
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _searchCategories,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body content
          Expanded(
            child: _categories.isEmpty
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while waiting
                : _filteredCategories.isEmpty
                    ? Center(child: Text("No categories available."))
                    : Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), // Adjust padding
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 8.0, // Reduced spacing between rows
                          ),
                          itemCount: _filteredCategories.length,
                          itemBuilder: (context, index) {
                            return CategoryCard(
                              categoryName: _filteredCategories[index]['nama_kategori'] ?? 'Unnamed Category',
                              categoryIcon: _getIconData(_filteredCategories[index]['icon_name'] ?? ''),
                              categoryId: _filteredCategories[index]['id_kategori'] ?? '',
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final String categoryId;

  CategoryCard({
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 246, 246, 246), // Set the card background color to white
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.white, // White outline
          width: 2.0,
        ),
      ),
      child: InkWell(
onTap: () {
          // Navigate to NavbarPage, passing the categoryId and setting the index to 2
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavbarUser(
                initialIndex: 2, // Set the index to 2 for PencarianPage
                idKategori: categoryId, // Pass the categoryId
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              size: 60.0,
              color: Colors.brown,
            ),
            const SizedBox(height: 8.0),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
