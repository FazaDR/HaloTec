import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:halotec/db/db_akun.dart';  // Import your existing login function
import 'package:halotec/page/user/home.dart'; // Import your user home page
import 'package:halotec/page/worker/homeWorker.dart'; // Import your worker home page
import 'package:halotec/page/worker/profileCompletion.dart';

Future<void> loginAndAuthenticate(String username, String password, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // Perform the login API request
  final response = await login(username, password); // Call your existing login function

  if (response != null && response.statusCode == 200) {
    final data = json.decode(response.body);
    
    if (data['status'] == 'success') {
      // Save authentication and user role in SharedPreferences
      prefs.setBool('isLoggedIn', true);
      prefs.setString('role', data['user']['role']);  // Assuming 'role' is part of the response
      prefs.setString('username', data['user']['username']);

      // Navigate to the appropriate page based on user role
      if (data['user']['role'] == 'user') {
        // Navigate to the normal user page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (data['user']['role'] == 'worker') {
        // Navigate to the worker page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompleteProfilePage()),
        );
      }
    } else {
      // Handle login failure
      print('Login failed: ${data['message']}');
    }
  } else {
    print('Login request failed');
  }
}
