import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/home.dart';
import 'package:sembilan_nih/View/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  final Color darkerOrange = const Color.fromARGB(255, 158, 95, 0);

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/pelanggan/login');

  try {
    final response = await http.post(
      url,
      body: json.encode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      if (responseData['message'] == 'Login berhasil') {
        // Ambil ID pengguna dari respons API
        final userId = responseData['data']['id_pelanggan']; // Sesuaikan dengan struktur respons API
        print('ID pengguna yang login: $userId');

        if (userId != null) {
          // Simpan ID pengguna ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userId);
          print('ID pengguna berhasil disimpan di SharedPreferences.');
        } else {
          throw Exception('ID pengguna tidak ditemukan di respons API.');
        }

        // Navigasi ke HomeView setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      } else {
        showAlertDialog(context, 'Login Gagal', responseData['message'] ?? 'Username atau password salah');
      }
    } else {
      showAlertDialog(context, 'Login Gagal', 'Terjadi kesalahan saat login');
    }
  } catch (e) {
    print('Error saat login: $e');
    showAlertDialog(context, 'Error', 'Tidak dapat terhubung ke server');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF333333)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/LOGO.png',
                            width: 400,
                            height: 100,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selamat Datang',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Username tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: usernameController,
                      hintTxt: "Username",
                      helperTxt: "",
                      iconData: Icons.person,
                      hintColor: Colors.grey,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 10),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: passwordController,
                      hintTxt: "Password",
                      helperTxt: "",
                      iconData: Icons.lock,
                      password: true,
                      hintColor: Colors.grey,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkerOrange,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginUser();
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Anda lupa password?',
                          style: TextStyle(color: darkerOrange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun?",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterView(),
                              ),
                            );
                          },
                          child: Text(
                            'Daftar Sekarang',
                            style: TextStyle(color: darkerOrange),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          'Ayo temukan kita',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.twitter),
                              color: darkerOrange,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.instagram),
                              color: darkerOrange,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.tiktok),
                              color: darkerOrange,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget inputForm(
    String? Function(String?)? validator, {
    required TextEditingController controller,
    required String hintTxt,
    required String helperTxt,
    required IconData iconData,
    bool password = false,
    Color hintColor = Colors.grey,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.white,
    Color iconColor = const Color.fromARGB(255, 158, 95, 0),
    bool insideIcon = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: password,
      decoration: InputDecoration(
        hintText: hintTxt,
        hintStyle: TextStyle(color: hintColor),
        fillColor: backgroundColor,
        filled: true,
        prefixIcon: insideIcon ? Icon(iconData, color: iconColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: textColor),
    );
  }
}
