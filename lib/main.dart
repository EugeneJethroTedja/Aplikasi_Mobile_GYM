import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/login.dart';
import 'package:sembilan_nih/View/home.dart';
import 'package:sembilan_nih/View/detail_pesanan.dart';
import 'package:sembilan_nih/View/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ego Gym',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
        '/detail_pesanan': (context) => const DetailPesananPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
