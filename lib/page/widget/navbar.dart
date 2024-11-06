import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.orange, // Set the selected icon color to make it visible
      unselectedItemColor: Colors.grey, // Set the unselected icon color
      type: BottomNavigationBarType.fixed, // Disable zoom effect on selected item
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
          icon: Icon(Icons.event),
          label: 'Pengajuan',
        ),
      ],
    );
  }
}
