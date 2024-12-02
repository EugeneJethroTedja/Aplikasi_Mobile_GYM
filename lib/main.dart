import 'package:sembilan_nih/View/home.dart';
import 'package:sembilan_nih/View/login.dart';
import 'package:sembilan_nih/profile/pagePertama.dart';
import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/detail_pesanan.dart';
import 'package:sembilan_nih/trainer/trainer.dart';
import 'package:sembilan_nih/alat/alat.dart';
import 'package:sembilan_nih/kelas/kelas.dart';


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
        '/profile': (context) => const ProfileScreen(),
        '/trainer': (context) => const TrainerScreen(),
        '/alat': (context) => const AlatScreen(),
        '/kelas': (context) => const KelasScreen(),
      },
    );
  }
}
