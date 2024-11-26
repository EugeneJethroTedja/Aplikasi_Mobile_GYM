import 'package:flutter/material.dart';
import 'kelas_detail.dart';

class Kelas {
  final String name;
  final String trainer;
  final String duration;
  final String day;
  final String fee;
  final String imageUrl;

  Kelas({
    required this.name,
    required this.trainer,
    required this.duration,
    required this.day,
    required this.fee,
    required this.imageUrl,
  });
}

class KelasScreen extends StatelessWidget {
  const KelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Kelas> kelases = [
      Kelas(
        name: 'Kelas Full Sixpack',
        trainer: 'Aaron',
        duration: '100 Menit',
        day: 'Rabu',
        fee: 'Rp 300.000',
        imageUrl: 'assets/images/kelassixpack.jpeg',
      ),
      Kelas(
        name: 'Kelas Leg day',
        trainer: 'Alif',
        duration: '90 Menit',
        day: 'Kamis',
        fee: 'Rp 140.000',
        imageUrl: 'assets/images/kelaslegday.jpg',
      ),
      Kelas(
        name: 'Kelas Upperchest',
        trainer: 'Lukman',
        duration: '60 Menit',
        day: 'Jumat',
        fee: 'Rp 200.000',
        imageUrl: 'assets/images/kelasupperchest.webp',
      ),
      Kelas(
        name: 'Kelas Aerobik',
        trainer: 'Ali',
        duration: '120 Menit',
        day: 'Sabtu',
        fee: 'Rp 250.000',
        imageUrl: 'assets/images/kelasaerobik.jpg',
      )
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 158, 95, 0),
        title: const Text(
          'Kelas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: kelases.length,
          itemBuilder: (context, index) {
            final kelas = kelases[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KelasDetailScreen(kelas: kelas),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        kelas.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            kelas.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 158, 95, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KelasDetailScreen(kelas: kelas),
                                ),
                              );
                            },
                            child: const Text(
                              'Detail Kelas',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
