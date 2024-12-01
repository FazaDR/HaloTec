import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveLoginData({
    required bool isLoggedIn,
    required String username,
    required String role,
    String? idWorker,
    String? idUser,
    String? nama,
    int? pengalamanKerja,
    String? rangeHarga,
    String? deskripsi,
    String? paymentPlan,
    String? profilePic,
    String? kategori,
    String? keahlian,
    String? alamat,
    String? telpon,
    String? gender,
    bool? isFirstLogin, // Add the `isFirstLogin` field
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('username', username);
    await prefs.setString('role', role);

    if (idWorker != null) prefs.setString('id_worker', idWorker);
    if (idUser != null) prefs.setString('id_user', idUser);
    if (nama != null) prefs.setString('nama', nama);
    if (pengalamanKerja != null) prefs.setInt('pengalaman_kerja', pengalamanKerja);
    if (rangeHarga != null) prefs.setString('range_harga', rangeHarga);
    if (deskripsi != null) prefs.setString('deskripsi', deskripsi);
    if (paymentPlan != null) prefs.setString('payment_plan', paymentPlan);
    if (profilePic != null) prefs.setString('profile_pic', profilePic);
    if (kategori != null) prefs.setString('kategori', kategori);
    if (keahlian != null) prefs.setString('keahlian', keahlian);
    if (alamat != null) prefs.setString('alamat', alamat);
    if (telpon != null) prefs.setString('telpon', telpon);
    if (gender != null) prefs.setString('gender', gender);

    if (isFirstLogin != null) {
      await prefs.setBool('isFirstLogin', isFirstLogin); // Save the `isFirstLogin` status
    }
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // New method: Retrieve user profile data
  static Future<Map<String, String?>> getUserProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'nama': prefs.getString('nama'),
      'telpon': prefs.getString('telpon'),
      'alamat': prefs.getString('alamat'),
      'gender': prefs.getString('gender'),
      'profile_pic': prefs.getString('profile_pic'),
    };
  }

  static Future<bool?> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn');
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_user');
  }

  static Future<bool?> getIsFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLogin');
  }
}
