import 'package:flutter/material.dart';
import 'package:halotec/page/user/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:halotec/db/db_akun.dart';
import 'dart:convert'; // For json.decode
import 'package:halotec/db/db_user_data.dart';
import 'package:halotec/util/SharedPreferences.dart';
import 'package:halotec/page/worker/homeWorker.dart'; // Import the worker home page
import 'package:halotec/page/worker/profileCompletion.dart'; // Import the worker profile page
import 'widget/RoundedInput.dart'; // Import your custom RoundedInput
import 'package:halotec/db/db_worker_data.dart'; // Import the worker data service
import 'package:halotec/page/user/navbar_user.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onRegisterTap;

  LoginPage({Key? key, required this.onRegisterTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  bool showUsernameWarning = false;
  bool showPasswordWarning = false;

  void dialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    setState(() {
      showUsernameWarning = usernameCont.text.isEmpty;
      showPasswordWarning = passCont.text.isEmpty;
    });

    if (!showUsernameWarning && !showPasswordWarning) {
      try {
        final response = await login(usernameCont.text, passCont.text);

        if (response != null && response.body.isNotEmpty) {
          var jsonResp = json.decode(response.body);

          if (jsonResp['status'] == 'success') {
            final user = jsonResp['user'];
            final role = user['role'];

            if (role == 'worker') {
              final workerData = await getWorkerData(user['username']);
              if (workerData != null) {
                bool isFirstLogin = workerData['is_first_login'] ?? true;

                await SharedPreferencesHelper.saveLoginData(
                  isLoggedIn: true,
                  username: user['username'],
                  role: role,
                  idWorker: workerData['id_worker'].toString(),
                  nama: workerData['nama'],
                  pengalamanKerja: workerData['pengalaman_kerja'],
                  rangeHarga: workerData['range_harga'],
                  deskripsi: workerData['deskripsi'],
                  paymentPlan: workerData['payment_plan'],
                  profilePic: workerData['profile_pic'] ?? 'https://example.com/default-profile-pic.png',
                  kategori: workerData['kategori'].toString(),
                  keahlian: workerData['keahlian'],
                  isFirstLogin: isFirstLogin, // Save isFirstLogin status
                );

                if (isFirstLogin) {
                  // Navigate to CompleteProfilePage for first-time login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CompleteProfilePage()),
                  );
                } else {
                  // Navigate to WorkerHomePage for returning workers
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WorkerHomePage()),
                  );
                }
              } else {
                dialog(context, 'Failed to fetch worker data.');
              }
            } else {
              final userData = await getUserData(user['username']);
              if (userData != null) {
                await SharedPreferencesHelper.saveLoginData(
                  isLoggedIn: true,
                  username: user['username'],
                  role: role,
                  idUser: userData['id_user'].toString(),
                  nama: userData['nama'],
                  alamat: userData['alamat'],
                  telpon: userData['telpon'],
                  gender: userData['gender'],
                  profilePic: userData['profile_pic'] ?? 'https://example.com/default-profile-pic.png',
                );

                // Navigate to NavbarUser for normal users
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarUser(),
                  ),
                );
              } else {
                dialog(context, 'Failed to fetch user data.');
              }
            }
          } else {
            dialog(context, jsonResp['message'] ?? 'Unknown error occurred');
          }
        } else {
          dialog(context, 'Username atau Password salah');
        }
      } catch (e) {
        dialog(context, 'Service unavailable. Please try again later.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 224, 173),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/login.png',
              height: MediaQuery.of(context).size.height * 0.375,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Login', style: TextStyle(fontSize: 40, color: Colors.black)),
                  SizedBox(height: 40),

                  // Username Input with RoundedInput
                  RoundedInput(
                    controller: usernameCont,
                    hintText: 'Username',
                    icon: Icons.person, // Custom icon for username
                    warningColor: Colors.red, // Custom warning color for errors
                    showWarning: showUsernameWarning,
                    warningText: 'Username harus diisi',
                  ),

                  // Password Input with RoundedInput
                  RoundedInput(
                    controller: passCont,
                    hintText: 'Password',
                    icon: Icons.lock, // Custom icon for password
                    warningColor: Colors.red, // Custom warning color for errors
                    showWarning: showPasswordWarning,
                    warningText: 'Password harus diisi',
                    isPassword: true,
                    showVisibilityIcon: true,
                  ),

                  Row(
                    children: [
                      Text('     Belum memiliki akun?', style: TextStyle(color: Colors.black, fontSize: 12)),
                      GestureDetector(
                        onTap: widget.onRegisterTap,
                        child: Text(
                          ' Daftar disini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 131, 70, 48),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _login,  // Call the login function
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFA5300F),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
