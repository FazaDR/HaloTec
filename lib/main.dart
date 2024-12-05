import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page/Auth.dart'; // Authentication Page
import 'page/worker/profileCompletion.dart'; // Worker Profile Completion Page
import 'page/worker/navbar_worker.dart'; // Worker Home Page
import 'page/user/navbar_user.dart'; // User Home Page

void main() {
  runApp(AppState());
}

/// Global app state to trigger app rebuild
class AppState extends StatelessWidget {
  static final ValueNotifier<int> appRefreshNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appRefreshNotifier,
      builder: (context, value, child) {
        return MyApp();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halotec',
      home: FutureBuilder<String>(
        future: determineStartPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 'CompleteProfilePage':
                return CompleteProfilePage();
              case 'WorkerHomePage':
                return WorkerNavbar();
              case 'UserHomePage':
                return NavbarUser(); // Directly navigate to NavbarUser
              default:
                return AuthPage();
            }
          }

          return AuthPage(); // Default case if no data
        },
      ),
    );
  }

  /// Determines the start page based on SharedPreferences data
  Future<String> determineStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role') ?? '';
    final isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

    if (isLoggedIn) {
      if (role == 'worker') {
        return isFirstLogin ? 'CompleteProfilePage' : 'WorkerHomePage';
      } else if (role == 'user') {
        return 'UserHomePage';
      }
    }
    return 'AuthPage';
  }

  /// Helper method to refresh the app
  void refreshApp() {
    AppState.appRefreshNotifier.value++;
  }

  /// Logout method: clears SharedPreferences and refreshes app state
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clear all stored data on logout

    // Refresh the app state to force a rebuild
    AppState.appRefreshNotifier.value++;

    // Navigate to the authentication page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }
}
