import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController notelpController;
  String? selectedGender;

  final Color darkerOrange = const Color.fromARGB(255, 158, 95, 0);

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    notelpController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    notelpController.dispose();
    super.dispose();
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
                            'assets/images/logo.png',
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
                          return "Username tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: usernameController,
                      hintTxt: "Username",
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
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                      controller: passwordController,
                      hintTxt: "Password",
                      iconData: Icons.lock,
                      password: true,
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
                      hint:
                          Text("Gender", style: TextStyle(color: Colors.grey)),
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
                            showAlertDialog(context, 'Registrasi Gagal',
                                'Panjang Nomor Telepon Harus 12 Digit!');
                          } else {
                            Map<String, dynamic> formData = {
                              'username': usernameController.text,
                              'password': passwordController.text,
                              'email': emailController.text,
                              'gender': selectedGender,
                              'notelp': notelpController.text,
                            };
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginView(data: formData),
                              ),
                            );
                          }
                        } else {
                          List<String> errorMessages = [];

                          if (usernameController.text.isEmpty) {
                            errorMessages.add('Username Tidak Boleh Kosong!');
                          }
                          if (passwordController.text.isEmpty) {
                            errorMessages.add('Password Tidak Boleh Kosong!');
                          }
                          if (emailController.text.isEmpty) {
                            errorMessages.add('Email Tidak Boleh Kosong!');
                          }
                          if (selectedGender == null) {
                            errorMessages.add('Gender Tidak Boleh Kosong!');
                          }
                          if (notelpController.text.isEmpty) {
                            errorMessages
                                .add('Nomor Telepon Tidak Boleh Kosong!');
                          }
                          if (emailController.text.isNotEmpty &&
                              !emailController.text.contains('@')) {
                            errorMessages
                                .add('Format Email Tidak Valid! (harus ada @)');
                          }

                          if (notelpController.text.length != 12 &&
                              notelpController.text.isNotEmpty) {
                            errorMessages
                                .add('Panjang Nomor Telepon Harus 12 Digit!');
                          }

                          if (errorMessages.isNotEmpty) {
                            showAlertDialog(context, 'Registrasi Gagal',
                                errorMessages.join(' && '));
                          }
                        }
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Text(
                      'ayo temukan kita',
                      style: TextStyle(color: Colors.grey[400]),
                      textAlign: TextAlign.center,
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
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: darkerOrange),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Text('Back', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
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
    FormFieldValidator<String>? validator, {
    required TextEditingController controller,
    required String hintTxt,
    required IconData iconData,
    bool password = false,
    Color? hintColor,
    Color? backgroundColor,
    Color? iconColor,
    bool insideIcon = false,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: password,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor,
        hintText: hintTxt,
        hintStyle: TextStyle(color: hintColor),
        prefixIcon: insideIcon ? Icon(iconData, color: iconColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
