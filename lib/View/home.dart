import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sembilan_nih/profile/pagePertama.dart'; 
import 'package:sembilan_nih/View/trainer.dart';
import 'package:sembilan_nih/View/alat.dart';
import 'package:sembilan_nih/View/kelas.dart';
import 'detail_pesanan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ego Gym',
      initialRoute: '/',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      routes: {
        '/': (context) => const HomeView(),
        '/detail_pesanan': (context) => const DetailPesananPage(),
        '/profile': (context) => const ProfileScreen(),
        '/trainer': (context) => const TrainerScreen(),
        '/alat': (context) => const AlatScreen(),
        '/kelas': (context) => const KelasScreen(),
      },
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/detail_pesanan');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.black),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 400,
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/alat.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6), 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tentang Kita',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ego Gym adalah aplikasi yang berguna untuk mempermudah para member gym agar mereka dapat memenuhi keperluan jasmani dengan lebih praktis dan tentunya anti ribet',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.info_outline, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              buildInfoCard(
                image: const AssetImage('assets/images/trainer.jpg'),
                title: 'TRAINER',
                routeName: '/trainer',
              ),

              const SizedBox(height: 16),
              buildInfoCard(
                image: const AssetImage('assets/images/alat.jpg'),
                title: 'ALAT',
                routeName: '/alat',
              ),

              const SizedBox(height: 16),
              buildInfoCard(
                image: const AssetImage('assets/images/kelas.jpeg'),
                title: 'KELAS',
                routeName: '/kelas',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required ImageProvider image,
    required String title,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image(
                image: image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
