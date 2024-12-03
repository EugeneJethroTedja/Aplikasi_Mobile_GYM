import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sembilan_nih/View/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController notelpController;
  late TextEditingController loginUsernameController;
  late TextEditingController loginPasswordController;
  late TextEditingController umurController;
  String? selectedGender;

  final Color darkerOrange = const Color.fromARGB(255, 158, 95, 0);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    notelpController = TextEditingController();
    loginUsernameController = TextEditingController();
    loginPasswordController = TextEditingController();
    umurController = TextEditingController(); // Inisialisasi controller umur
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    notelpController.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    umurController.dispose(); // Hapus controller umur
    super.dispose();
  }

  Future<void> registerUser() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/pelanggan/register'); // Ganti dengan URL endpoint Anda
    final response = await http.post(
      url,
      body: json.encode({
        'nama_pelanggan': nameController.text,
        'umur_pelanggan': umurController.text,
        'email_pelanggan': emailController.text,
        'noTelp_pelanggan': notelpController.text,
        'gender': selectedGender,
        'username': loginUsernameController.text,
        'password': loginPasswordController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['message'] == 'Pelanggan berhasil didaftarkan') {
        // Navigasi ke halaman login jika berhasil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginView(), // Arahkan ke halaman login
          ),
        );
      } else {
        showAlertDialog(context, 'Registrasi Gagal', responseData['message']);
      }
    } else {
      showAlertDialog(context, 'Registrasi Gagal', 'Terjadi kesalahan saat mendaftar ${response.body}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF333333)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 100),
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
                            'Daftar Member Baru',
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
                          return "Nama tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: nameController,
                      hintTxt: "Nama",
                      iconData: Icons.person,
                      hintColor: Colors.grey,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 10),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Umur tidak boleh kosong";
                        }
                        if (int.tryParse(p0) == null || int.parse(p0) <= 0) {
                          return 'Umur harus berupa angka positif';
                        }
                        return null;
                      },
                      controller: umurController,
                      hintTxt: "Umur",
                      iconData: Icons.cake,
                      hintColor: Colors.grey,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 10),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!p0.contains('@')) {
                          return 'Email harus menggunakan @';
                        }
                        return null;
                      },
                      controller: emailController,
                      hintTxt: "Email",
                      iconData: Icons.email,
                      hintColor: Colors.grey,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      hint: Text("Gender", style: TextStyle(color: Colors.grey)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(FontAwesomeIcons.venusMars,
                            color: darkerOrange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                      items: <String>['Laki-laki', 'Perempuan']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Nomor Telepon tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: notelpController,
                      hintTxt: "Nomor Telepon",
                      iconData: Icons.phone,
                      hintColor: Colors.grey,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 10),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Username Login tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: loginUsernameController,
                      hintTxt: "Username Login",
                      iconData: Icons.account_circle,
                      hintColor: Colors.grey,
                      backgroundColor: Colors.white,
                      iconColor: darkerOrange,
                      insideIcon: true,
                    ),
                    const SizedBox(height: 10),
                    inputForm(
                      (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Password Login tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: loginPasswordController,
                      hintTxt: "Password Login",
                      iconData: Icons.lock,
                      password: true,
                      hintColor: Colors.grey,
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
                        if (_formKey.currentState!.validate() &&
                            selectedGender != null) {
                          if (notelpController.text.length != 12) {
                            showAlertDialog(
                                context, 'Registrasi Gagal',
                                'Panjang Nomor Telepon Harus 12 Digit!');
                          } else {
                            registerUser();
                          }
                        } else {
                          List<String> errorMessages = [];

                          if (nameController.text.isEmpty) {
                            errorMessages.add('Nama Tidak Boleh Kosong!');
                          }
                          if (emailController.text.isEmpty) {
                            errorMessages.add('Email Tidak Boleh Kosong!');
                          }
                          if (selectedGender == null) {
                            errorMessages.add('Gender Tidak Boleh Kosong!');
                          }
                          if (notelpController.text.isEmpty) {
                            errorMessages.add('Nomor Telepon Tidak Boleh Kosong!');
                          }
                          if (loginUsernameController.text.isEmpty) {
                            errorMessages.add('Username Login Tidak Boleh Kosong!');
                          }
                          if (loginPasswordController.text.isEmpty) {
                            errorMessages.add('Password Login Tidak Boleh Kosong!');
                          }

                          if (errorMessages.isNotEmpty) {
                            showAlertDialog(
                                context, 'Registrasi Gagal',
                                errorMessages.join('\n'));
                          }
                        }
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget inputForm(
    String? Function(String?) validator, {
    required TextEditingController controller,
    required String hintTxt,
    required IconData iconData,
    required Color hintColor,
    required Color backgroundColor,
    required Color iconColor,
    bool password = false,
    bool insideIcon = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: password,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor,
        prefixIcon: insideIcon
            ? Icon(iconData, color: iconColor)
            : null,
        hintText: hintTxt,
        hintStyle: TextStyle(color: hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}