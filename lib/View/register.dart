import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembilan_nih/View/login.dart';
import 'package:sembilan_nih/component/form_component.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController alamatController = TextEditingController(); 
  TextEditingController jenisKelaminController = TextEditingController(); 
  TextEditingController tinggiBadanController = TextEditingController(); 
  TextEditingController beratBadanController = TextEditingController(); 
  TextEditingController usiaController = TextEditingController();

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('notelp', notelpController.text);
    await prefs.setString('alamat', alamatController.text); 
    await prefs.setString('jenisKelamin', jenisKelaminController.text); 
    await prefs.setString('tinggiBadan', tinggiBadanController.text); 
    await prefs.setString('beratBadan', beratBadanController.text);
    await prefs.setString('usia', usiaController.text);
    await prefs.setString('password', passwordController.text); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Username Tidak Boleh Kosong';
                }
                return null;
              },
              controller: usernameController,
              hintTxt: "Username",
              helperTxt: "Masukkan Username Anda",
              iconData: Icons.person),

              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Email Tidak Boleh Kosong';
                }
                return null;
              },
              controller: emailController,
              hintTxt: "Email",
              helperTxt: "Masukkan Email Anda",
              iconData: Icons.email),

              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Password Tidak Boleh Kosong';
                }
                return null;
              },
              controller: passwordController,
              hintTxt: "Password",
              helperTxt: "Masukkan Password Anda",
              iconData: Icons.password,
              password: true),

              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Nomor Telepon Tidak Boleh Kosong';
                }
                return null;
              },
              controller: notelpController,
              hintTxt: "No Telp",
              helperTxt: "Masukkan Nomor Telepon Anda",
              iconData: Icons.phone_android),

              
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
              controller: alamatController,
              hintTxt: "Alamat",
              helperTxt: "Jl. Babarsari Gotham City",
              iconData: Icons.home),

              
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Jenis Kelamin harus diisi';
                }
                if (!p0.contains('P') && !p0.contains('L')) {
                  return 'Jenis Kelamin Hanya L/P';
                }
                return null;
              },
              controller: jenisKelaminController,
              hintTxt: "Jenis Kelamin",
              helperTxt: "Masukkan Jenis Kelamin (L/P)",
              iconData: Icons.person),

          
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Tinggi Badan harus diisi';
                }
                return null;
              },
              controller: tinggiBadanController,
              hintTxt: "Tinggi Badan",
              helperTxt: "Contoh: 180cm",
              iconData: Icons.height),

              
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Berat Badan harus diisi';
                }
                return null;
              },
              controller: beratBadanController,
              hintTxt: "Berat Badan",
              helperTxt: "Contoh: 80kg",
              iconData: Icons.fitness_center),

            
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Usia harus diisi';
                }
                return null;
              },
              controller: usiaController,
              hintTxt: "Usia",
              helperTxt: "Contoh: 20 th",
              iconData: Icons.cake),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveData(); 
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginView(
                          data: {
                            'username': usernameController.text,
                            'password': passwordController.text,
                          },
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
