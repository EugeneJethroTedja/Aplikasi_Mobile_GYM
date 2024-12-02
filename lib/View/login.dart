import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/home.dart';
import 'package:sembilan_nih/View/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  final Map? data;

  const LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  Map? dataForm;

  final Color darkerOrange = const Color.fromARGB(255, 158, 95, 0);

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    dataForm = widget.data;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
                        if (usernameController.text.isEmpty &&
                            passwordController.text.isEmpty) {
                          showAlertDialog(context, 'Login Gagal',
                              'Belum memasukan Username dan Password!');
                        } else if (usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          showAlertDialog(context, 'Login Gagal',
                              'Username atau Password yang Anda masukkan salah.');
                        } else if (_formKey.currentState!.validate()) {
                          if (dataForm != null &&
                              dataForm!['username'] ==
                                  usernameController.text &&
                              dataForm!['password'] ==
                                  passwordController.text) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeView(),
                              ),
                            );
                          } else {
                            showAlertDialog(context, 'Login Gagal',
                                'Username atau Password yang Anda masukkan salah.');
                          }
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
                            pushRegister(context);
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

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ),
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
