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

    if (idWorker != null) prefs.setString('id_worker', idWorker);//worker
    if (idUser != null) prefs.setString('id_user', idUser);//user
    if (nama != null) prefs.setString('nama', nama);//worker&user
    if (pengalamanKerja != null) prefs.setInt('pengalaman_kerja', pengalamanKerja);//worker
    if (rangeHarga != null) prefs.setString('range_harga', rangeHarga);//worker
    if (deskripsi != null) prefs.setString('deskripsi', deskripsi);//user
    if (paymentPlan != null) prefs.setString('payment_plan', paymentPlan);//worker
    if (profilePic != null) prefs.setString('profile_pic', profilePic);//worker&user
    if (kategori != null) prefs.setString('kategori', kategori);//worker
    if (keahlian != null) prefs.setString('keahlian', keahlian);//worker
    if (alamat != null) prefs.setString('alamat', alamat);//user
    if (telpon != null) prefs.setString('telpon', telpon);//worker&user
    if (gender != null) prefs.setString('gender', gender);//user

    if (isFirstLogin != null) {
      await prefs.setBool('isFirstLogin', isFirstLogin); 
    }
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String?>> getWorkerData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'id_worker': prefs.getString('id_worker'),
      'username':prefs.getString('username'), 
      'nama': prefs.getString('nama'),
      'pengalaman_kerja': prefs.getInt('pengalaman_kerja')?.toString(),
      'range_harga': prefs.getString('range_harga'),
      'payment_plan': prefs.getString('payment_plan'),
      'profile_pic': prefs.getString('profile_pic'),
      'kategori': prefs.getString('kategori'),
      'keahlian': prefs.getString('keahlian'),
      'deskripsi':prefs.getString('deskripsi'),
      'telpon': prefs.getString('telpon')
    };
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

  static Future<String?> getWorkerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_worker');
  }
}
