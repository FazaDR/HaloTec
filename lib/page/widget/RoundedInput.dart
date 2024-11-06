import 'package:flutter/material.dart';

Widget RoundedInput(String hintText, IconData icon) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(fontSize: 12, color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey), // Set hint (label) color to grey
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              border: InputBorder.none,
            ),
          ),
        ),
        Icon(
          icon, // Using the icon passed as a parameter
          color: Colors.grey,
        ),
        SizedBox(width: 10), // Spacing between text and icon
      ],
    ),
  );
}
