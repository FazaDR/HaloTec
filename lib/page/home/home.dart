import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to track the selected index of the bottom navigation bar
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    Center(child: Text('Home Page Content')),
    Center(child: Text('Profile Page Content')),
    Center(child: Text('Pencarian Page Content')),
    Center(child: Text('Pengajuan Page Content')),
  ];

  // Method to handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 241, 203), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB74D), // AppBar color
        automaticallyImplyLeading: false, // Remove the back button
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HaloTec',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 17), // Space between title and search bar
            Container(
              height: 45, // Height of the search bar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 10), // Center the text vertically
                  ),
                ),
              ),
            ),
          ],
        ),
        toolbarHeight: 150, // Increase AppBar height to fit the search bar
      ),
      body: _pages[_selectedIndex], // Display the selected page content
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pencarian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Pengajuan',
          ),
        ],
      ),
    );
  }
}
