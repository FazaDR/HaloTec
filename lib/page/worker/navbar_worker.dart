import 'package:flutter/material.dart';
import 'profile.dart'; // Profile page for workers
import 'home_tukang.dart'; // Home page for workers
import 'review.dart'; // Review page
import 'package:halotec/util/SharedPreferences.dart'; // Utility for session management
import 'package:halotec/page/Auth.dart'; // Authentication page

class WorkerNavbar extends StatefulWidget {
  final int initialIndex; // Initial index for navigation

  const WorkerNavbar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _WorkerNavbarState createState() => _WorkerNavbarState();
}

class _WorkerNavbarState extends State<WorkerNavbar> {
  late int _selectedIndex; // Current index for navigation
  late final List<Widget> _pages; // Pages for navigation

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set initial index from the parameter
    _pages = [
      const ProfilePage(), // ProfilePage
      HomeTukangPage(), // Home page for workers
      ReviewPage(), // Reviews page
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesHelper.clearPreferences(); // Clear session data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()), // Navigate to AuthPage
      (route) => false, // Clear navigation stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 225), // Background color
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Keep all pages in memory
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Prevent the "pop out" effect
        selectedItemColor: Colors.orange, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
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
            icon: Icon(Icons.star),
            label: 'Review',
          ),
        ],
      ),
    );
  }
}
