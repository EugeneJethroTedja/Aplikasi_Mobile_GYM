import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'kelas_detail.dart';

class Kelas {
  final String name;
  final String trainer;
  final int duration;
  final String day;
  final int fee;
  final String imageUrl;

  Kelas({
    required this.name,
    required this.trainer,
    required this.duration,
    required this.day,
    required this.fee,
    required this.imageUrl,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      name: json['name'] ?? '',
      trainer: json['trainer']['name'] ?? '',
      duration: int.tryParse(json['duration'].toString()) ?? 0,
      day: json['day'] ?? '',
      fee: int.tryParse(json['fee'].toString()) ?? 0,
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

  Future<void> fetchKelases() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/kelas/'));

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
  void initState() {
    super.initState();
    fetchKelases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 158, 95, 0),
        title: const Text(
          'Kelas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
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
                                              builder: (context) => KelasDetailScreen(kelas: kelas),
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
