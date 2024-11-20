import 'package:flutter/material.dart';

class RoundedInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon; // Custom icon parameter
  final Color? warningColor; // Custom warning color parameter
  final bool isPassword;
  final bool showWarning;
  final String? warningText;
  final bool showVisibilityIcon; // New parameter to decide if the visibility icon should be shown

  const RoundedInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.warningColor,
    this.isPassword = false,
    this.showWarning = false,
    this.warningText,
    this.showVisibilityIcon = false, // Default to true for showing the visibility icon
  }) : super(key: key);

  @override
  _RoundedInputState createState() => _RoundedInputState();
}

class _RoundedInputState extends State<RoundedInput> {
  bool obscureText = true; // This controls the password visibility

  // Toggle password visibility
  void _toggleVisibility() {
    setState(() {
      obscureText = !obscureText; // Toggle the password visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: widget.showWarning ? 0 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.isPassword ? obscureText : false, // Apply the toggle
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Show the visibility toggle only if 'showVisibilityIcon' is true
              if (widget.isPassword && widget.showVisibilityIcon)
                IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleVisibility, // Toggle visibility when clicked
                )
              else if (widget.isPassword)
                // Show a default icon (e.g., a lock) when no visibility toggle is needed
                Icon(
                  widget.icon ?? Icons.lock, // Default lock icon
                  color: Colors.grey,
                )
              else
                Icon(
                  widget.icon ?? Icons.person, // Default or custom icon for non-password fields
                  color: Colors.grey,
                ),
              SizedBox(width: 10),
            ],
          ),
        ),
        // Display warning text if required
        if (widget.showWarning)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 20),
            child: Align(
              alignment: Alignment.centerLeft, // Align the warning text to the left
              child: Text(
                widget.warningText ?? 'This field is required',
                style: TextStyle(
                  color: widget.warningColor ?? Colors.red, // Use custom warning color if provided
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
