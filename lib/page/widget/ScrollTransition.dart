import 'package:flutter/material.dart';
//CURRENTLY NOT USED !!!!!

// Function to create a connected scrolling transition
Route ScrollTransition(Widget page, bool isScrollDown) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 700), // Slower duration for smooth effect
    reverseTransitionDuration: const Duration(milliseconds: 700),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffsetDown = Offset(0, 1);  // Scroll down
      const beginOffsetUp = Offset(0, -1);   // Scroll up
      final beginOffset = isScrollDown ? beginOffsetDown : beginOffsetUp;
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      // Slide transition with smooth easing
      final slideTween = Tween(begin: beginOffset, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(slideTween);

      // Fade transition to enhance the connected effect
      final fadeTween = Tween<double>(begin: 0.7, end: 1.0); // Slight fade in/out
      final fadeAnimation = animation.drive(CurveTween(curve: Curves.easeOut)).drive(fadeTween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}
