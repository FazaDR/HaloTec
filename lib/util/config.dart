import 'dart:io'; // Import the dart:io library

// Function to get the base URL dynamically
String _determineApiBaseUrl() {
  if (Platform.isAndroid || Platform.isIOS) {
    return 'http://192.168.172.242'; // Replace with your mobile IP
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    return 'http://localhost';
  } else {
    return 'http://localhost'; // Fallback
  }
}

// Determine the base URL once and store it in a constant
final String apiBaseUrl = _determineApiBaseUrl();
