import 'package:flutter/material.dart';
import 'page/widget/Auth.dart'; // Adjust the import according to your file structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halotec',
      home: AuthPage(), // Use your AuthPage that contains the PageView
    );
  }
}
