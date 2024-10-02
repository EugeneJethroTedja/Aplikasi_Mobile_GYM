import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/login.dart';
import 'package:sembilan_nih/component/form_component.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //* untuk validasi harus menggunakan GlobalKey
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController umurController = TextEditingController();
  TextEditingController tinggiBadanController = TextEditingController();
  TextEditingController beratBadanController = TextEditingController();
  TextEditingController jenisKelaminController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputForm(
              (p0) {
                if(p0 == null || p0.isEmpty)
                {
                  return 'Username tidak boleh kosong';
                }
                if(p0.toLowerCase() == 'anjing' || p0.toLowerCase() == 'bangsat'){
                  return 'Tidak boleh menggunakan kata kasar';
                }
                return null;
              },
                controller: usernameController,
                hintTxt: "Username",
                helperTxt: "John Doe",
                iconData: Icons.person),
              inputForm(
              ((p0){
                //* untuk menglihat contoh penggunaan regex, uncoment baris dibawah yang dicomment
                // final 
                if(p0 == null || p0.isEmpty)
                {
                  return 'Umur tidak boleh kosong';
                }
                // if(!regex.hasMatch(p0))
                //{
                  // return "Nomor Telefon tidak valid";
                //}
                return null;
              }),
              controller: umurController,
              hintTxt: "Umur",
              helperTxt: "Contoh: 16",
              iconData: Icons.numbers),
              inputForm(
              ((p0){
                //* untuk menglihat contoh penggunaan regex, uncoment baris dibawah yang dicomment
                // final 
                if(p0 == null || p0.isEmpty)
                {
                  return 'Tinggi Badan tidak boleh kosong';
                }
                // if(!regex.hasMatch(p0))
                //{
                  // return "Nomor Telefon tidak valid";
                //}
                return null;
              }),
              controller: tinggiBadanController,
              hintTxt: "Tinggi Badan",
              helperTxt: "Contoh: 182 CM",
              iconData: Icons.height_outlined),
              inputForm(
              ((p0){
                //* untuk menglihat contoh penggunaan regex, uncoment baris dibawah yang dicomment
                // final 
                if(p0 == null || p0.isEmpty)
                {
                  return 'Berat Badan tidak boleh kosong';
                }
                // if(!regex.hasMatch(p0))
                //{
                  // return "Nomor Telefon tidak valid";
                //}
                return null;
              }),
              controller: beratBadanController,
              hintTxt: "Berat Badan",
              helperTxt: "Contoh: 74",
              iconData: Icons.numbers),
              inputForm(
                ((p0){
                  if(p0 == null || p0.isEmpty)
                  {
                    return 'jenis Kelamin Tidak boleh kosong';
                  }
                  if(!p0.contains('L') && !p0.contains('P'))
                  {
                    return 'Jenis Kelamin Hanya Boleh (L/P) !';
                  }
                  return null;
                }),
                controller: jenisKelaminController,
                hintTxt: "Jenis Kelamin",
                helperTxt: "L: laki-laki atau P: perempuan",
                iconData: Icons.man),
              inputForm(
                ((p0){
                  if(p0 == null || p0.isEmpty)
                  {
                    return 'Email Tidak boleh kosong';
                  }
                  if(!p0.contains('@'))
                  {
                    return 'Email harus menggunakan @';
                  }
                  return null;
                }),
                controller: emailController,
                hintTxt: "Email",
                helperTxt: "ucup@gmail.com",
                iconData: Icons.email),
            inputForm(
              //* Pola validasi lebih detail bisa menggunakan regex
              ((p0){
                if(p0 == null || p0.isEmpty)
                {
                  return 'Password tidak boleh kosong';
                }
                if(p0.length<5)
                {
                  return 'Password minimal 5 digit';
                }
                return null;
              }),
              controller: passwordController,
              hintTxt: "Password",
              helperTxt: "xxxxxxx",
              iconData: Icons.password,
              password: true),
            inputForm(
              ((p0){
                //* untuk menglihat contoh penggunaan regex, uncoment baris dibawah yang dicomment
                // final 
                if(p0 == null || p0.isEmpty)
                {
                  return 'Nomor Telefon tidak boleh kosong';
                }
                // if(!regex.hasMatch(p0))
                //{
                  // return "Nomor Telefon tidak valid";
                //}
                return null;
              }),
              controller: notelpController,
              hintTxt: "No Telp",
              helperTxt: "092123456789",
              iconData: Icons.phone_android),
          ElevatedButton(
            onPressed: () {
              if(_formKey.currentState!.validate()) {
                Map<String, dynamic> formData = {};
                formData['username'] = usernameController.text;
                formData['password'] = passwordController.text;
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoginView(data: formData ,)) );
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