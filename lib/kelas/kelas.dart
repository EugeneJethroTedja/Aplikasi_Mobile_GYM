import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'kelas_detail.dart';

class Kelas {
  final int id; 
  final String nameKelas;
  final String trainer;
  final int durationKelas;
  final String dayKelas;
  final int feeKelas;
  final String imageUrl;

  Kelas({
    required this.id,
    required this.nameKelas,
    required this.trainer,
    required this.durationKelas,
    required this.dayKelas,
    required this.feeKelas,
    required this.imageUrl,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id_kelas'] ?? 0,
      nameKelas: json['name'] ?? '',
      trainer: json['trainer'] != null
          ? (json['trainer']['nama_trainer'] ?? '') 
          : '', 
      durationKelas: int.tryParse(json['duration'].toString()) ?? 0,
      dayKelas: json['day'] ?? '',
      feeKelas: int.tryParse(json['fee'].toString()) ?? 0,
      imageUrl: json['imageUrl'] ?? 'assets/images/default_image.png',
    );
  }
}

class KelasScreen extends StatefulWidget {
  const KelasScreen({super.key});

  @override
  State<KelasScreen> createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  List<Kelas> kelases = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchKelases();
  }

  Future<void> fetchKelases() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/kelas/'),
      );

      if (response.statusCode == 200) {
        List<dynamic> kelasesJson = json.decode(response.body);
        setState(() {
          kelases = kelasesJson.map((json) => Kelas.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          kelases = [];
        });
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching kelases: $e");
      setState(() {
        isLoading = false;
        kelases = [];
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/detail_pesanan');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/home');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text(
          'Kelas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: kelases.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada kelas tersedia',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: kelases.length,
                      itemBuilder: (context, index) {
                        final kelas = kelases[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    KelasDetailScreen(kelas: kelas),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kelas.nameKelas,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Trainner: ${kelas.trainer}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'Durasi: ${kelas.durationKelas} menit',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'Hari: ${kelas.dayKelas}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'Biaya: Rp ${kelas.feeKelas}',
                                        style: const TextStyle(
                                            color: Colors.black),
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
    );
  }
}
