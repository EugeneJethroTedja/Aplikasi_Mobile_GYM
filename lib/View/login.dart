import 'package:flutter/material.dart';
//* Sesuai dengan nama project anda, awalnya akan error pada home, register, form component belum dibuat
import 'package:sembilan_nih/View/home.dart';
import 'package:sembilan_nih/View/register.dart';
import 'package:sembilan_nih/component/form_component.dart';

class LoginView extends StatefulWidget {
  //* variabel map data dibuat bersifat nullable, karena ketika aplikasi dijalankan(dipanggil dari main, tidak ada data yang dibawa)
  //* data memiliki nilai ketika registrasi berhasil dilakukan
  final Map? data; 
  //* Agar map data bisa bersifat nullable, pada constructor dibungkus dengan kurung { } agar bersifat opsional
  const LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //* TextEditingController
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    //* Widget mengacu pada instance/objek Loginview
    Map? dataForm = widget.data;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //* Username
              inputForm((p0) {
                if(p0 == null || p0.isEmpty) {
                  return "username tidak boleh kosong";
                }
                return null;
              },
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Inputkan User yang telah didaftar",
                  iconData: Icons.person),
              //* Password
              inputForm((p0) {
                if(p0 == null || p0.isEmpty){
                  return "password kosong";
                }
                return null;
              },
                  password: true,
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "Inputkan Password",
                  iconData: Icons.password),
              //* Baris yang berisi tombol login dan tombol mengarah kehalaman register
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //* tombol Login
                  ElevatedButton(
                    //* fungsi yang dijalankan saat tombol ditekan
                    onPressed: () {
                      //* cek state sudah valid atau belum valid
                      if(_formKey.currentState!.validate()) {
                        //* jika sudah valid, cek username dan password yang diinputkan pada form telah sesuai dengan data yang dibawah
                        //* dari halaman register atau belum
                        if(dataForm!['username'] == usernameController.text && dataForm['password'] == passwordController.text)
                        {
                          //*jika sesuai navigasi ke halaman home
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>const HomeView()));
                        }else{
                          //*jika belum tampilkan alert dialog
                          showDialog(context: context, builder:(_)=>AlertDialog(
                            title: const Text('Password Salah'),
                            //*isi Alert Dialog
                            content: TextButton(
                              //*pushRegister(context) fungsi pada baris 118-124 untuk meminimalkan nested code
                              onPressed: () =>pushRegister(context),
                              child: const Text('Daftar Disini !!')),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                            ),);
                        }
                      }
                    },
                    child: const Text('Login')),
                //*tombol ke halaman register
                TextButton(
                  onPressed: () {
                    Map<String, dynamic> formData = {};
                    formData['username'] = usernameController.text;
                    formData['password'] = passwordController.text;
                    pushRegister(context);
                  },
                  child: const Text('Belum punya akun ?')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void pushRegister(BuildContext context) {
    Navigator.push(context,MaterialPageRoute(builder: (_) => const RegisterView(),),);
  }
}

