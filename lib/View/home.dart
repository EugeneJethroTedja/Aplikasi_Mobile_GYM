import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sembilan_nih/profile/pagePertama.dart'; 
import 'package:sembilan_nih/trainer/trainer.dart';
import 'package:sembilan_nih/alat/alat.dart';
import 'package:sembilan_nih/kelas/kelas.dart';
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

  // Fungsi untuk mendapatkan lokasi pengguna
  Future<String> _getUserLocation() async {
  debugPrint('Memulai pengambilan lokasi pengguna...');
  
  try {
    // Periksa apakah layanan lokasi aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Layanan lokasi tidak aktif.');
      return 'Layanan lokasi tidak aktif';
    }
    debugPrint('Layanan lokasi aktif.');

    // Periksa izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint('Status izin lokasi saat ini: $permission');

    if (permission == LocationPermission.denied) {
      debugPrint('Izin lokasi ditolak. Meminta izin...');
      permission = await Geolocator.requestPermission();
      debugPrint('Status izin lokasi setelah meminta: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('Izin lokasi tetap ditolak.');
        return 'Izin lokasi ditolak';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Izin lokasi ditolak secara permanen.');
      return 'Izin lokasi ditolak secara permanen';
    }

    debugPrint('Izin lokasi diberikan. Memulai pengambilan koordinat lokasi...');

    // Dapatkan posisi pengguna
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 5),
    );
    debugPrint(
        'Lokasi diperoleh: Latitude=${position.latitude}, Longitude=${position.longitude}');

    // Ubah koordinat menjadi alamat
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'id_ID', // Lokalisasi ke Bahasa Indonesia
    );

    debugPrint('Placemarks ditemukan: ${placemarks.length}');
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String city = place.locality ?? place.subAdministrativeArea ?? '';
      String country = place.country ?? '';

      if (city.isNotEmpty && country.isNotEmpty) {
        debugPrint('Lokasi pengguna: $city, $country');
        return '$city, $country';
      } else if (city.isNotEmpty) {
        debugPrint('Lokasi pengguna (kota): $city');
        return city;
      } else if (country.isNotEmpty) {
        debugPrint('Lokasi pengguna (negara): $country');
        return country;
      }
    }

    debugPrint('Placemarks tidak memuat data lokasi yang valid.');
    return 'Lokasi tidak ditemukan';
  } catch (e) {
    debugPrint('Terjadi error saat mendapatkan lokasi: $e');
    return 'Gagal mendapatkan lokasi';
  }
}

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
              Center(
                child: Image.asset(
                  'assets/images/LOGO.png',
                  width: 400,
                  height: 100,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: _getUserLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mencari lokasi...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Gagal mendapatkan lokasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          snapshot.data ?? 'Lokasi tidak ditemukan',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/bangunangym.webp'),
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
