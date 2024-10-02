import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                if (p0.toLowerCase() == 'anjing') {
                  return 'Tidak boleh menggunakan kata kasar';
                }
                return null;
              },
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Ucup Surucup",
                  iconData: Icons.person),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!p0.contains('@')) {
                  return 'Email harus menggunakan @';
                }
                return null;
              }),
                  controller: emailController,
                  hintTxt: "Email",
                  helperTxt: "ucup@gmail.com",
                  iconData: Icons.email),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (p0.length < 5) {
                  return 'Password minimal 5 digit';
                }
                return null;
              }),
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "xxxxxx",
                  iconData: Icons.password,
                  password: true),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Nomor Telepon tidak boleh kosong';
                }
                return null;
              }),
                  controller: notelpController,
                  hintTxt: "No Telp",
                  helperTxt: "082123456789",
                  iconData: Icons.phone_android),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Alamat harus diisi';
                }
                return null;
              }),
                  controller: alamatController,
                  hintTxt: "Alamat",
                  helperTxt: "Jl.Babarsari Gotham City",
                  iconData: Icons.person),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Jenis Kelamin harus diisi';
                }
                if (!p0.contains('P') && !p0.contains('L')) {
                  return 'Jenis Kelamin Hanya L/P';
                }
                return null;
              }),
                  controller: jenisKelaminController,
                  hintTxt: "Jenis Kelamin",
                  helperTxt: "L/P",
                  iconData: Icons.person),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Tinggi Badan harus diisi';
                }
                return null;
              }),
                  controller: tinggiBadanController,
                  hintTxt: "Tinggi Badan",
                  helperTxt: "180cm",
                  iconData: Icons.person),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Berat Badan harus diisi';
                }
                return null;
              }),
                  controller: beratBadanController,
                  hintTxt: "Berat Badan",
                  helperTxt: "80kg",
                  iconData: Icons.person),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Usia harus diisi';
                }
                return null;
              }),
                  controller: usiaController,
                  hintTxt: "Usia",
                  helperTxt: "20 th",
                  iconData: Icons.person),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> formData = {};
                      formData['username'] = usernameController.text;
                      formData['password'] = passwordController.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LoginView(
                                    data: formData,
                                  )));
                    }
                  },
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
