import 'package:flutter/material.dart';
import 'profile.dart';
import 'pencarian.dart';
import 'home.dart'; // Import the HomePage
import 'pengajuan.dart'; // Import the PengajuanPage
import 'package:halotec/page/Auth.dart';
import 'package:halotec/util/SharedPreferences.dart';

class NavbarUser extends StatefulWidget {
  final int initialIndex; // Accept the initial index as a parameter
  final String? idKategori; // Add a parameter for id_kategori

  // Constructor that takes the initial index and id_kategori
  const NavbarUser({Key? key, this.initialIndex = 1, this.idKategori}) : super(key: key);

  @override
  _NavbarUserState createState() => _NavbarUserState();
}

class _NavbarUserState extends State<NavbarUser> {
  late int _selectedIndex; // This will store the current index
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set the initial index from the constructor
    _pages = [
      ProfilePage(), // ProfilePage now fetches data internally
      HomePage(), // HomePage
      PencarianPage(selectedCategoryId: widget.idKategori ?? ''), // Pass id_kategori to PencarianPage
      PengajuanPage(), // PengajuanPage
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesHelper.clearPreferences(); // Clear preferences
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()), // Navigate to AuthPage
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 225), // Background color
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Keep all pages in memory and show the selected one
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Prevent the "pop out" effect
        selectedItemColor: Colors.orange, // Selected item color (orange)
        unselectedItemColor: Colors.grey, // Unselected item color (grey)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pencarian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Pengajuan',
          ),
        ],
      ),
    );
  }
}
