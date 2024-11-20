import 'package:sembilan_nih/home.dart';
import 'package:sembilan_nih/View/login.dart'; 
import 'package:sembilan_nih/profile/pagePertama.dart'; 
import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/detail_pesanan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return const MaterialApp(
      home: Scaffold(
        body: Center(
<<<<<<< HEAD
          child: Text('Octavionus Samuel - 220711661'),
=======
          child: Text('Octavionus Samuel Kusuma Wardana-220711661'),
>>>>>>> ea110d0105f8fa95b5228827dc55c878bb137851
        ),
      ),
=======
    return MaterialApp(
      title: 'Ego Gym',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
        '/detail_pesanan': (context) => const DetailPesananPage(),
        '/profile': (context) => const ProfileScreen(),
      },
>>>>>>> 6d2ad2fa403fd3234eb3a42b653748b22c4f6784
    );
  }
}
