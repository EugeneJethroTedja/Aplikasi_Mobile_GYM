import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'alat_detail.dart';

class Alat {
  final int id;
  final String nameAlat;
  final String deskripsi;
  final int stok;
  final int feeAlat;
  final String imageUrl;

  Alat({
    required this.id,
    required this.nameAlat,
    required this.deskripsi,
    required this.stok,
    required this.feeAlat,
    required this.imageUrl,
  });

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      id: json['id_alat'] ?? '',
      nameAlat: json['nameAlat'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      stok: json['stok'] ?? '',
      feeAlat: json['feeAlat'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/treadmill.jpg',
    );
  }
}

class AlatScreen extends StatefulWidget {
  const AlatScreen({super.key});

  @override
  State<AlatScreen> createState() => _AlatScreenState();
}

class _AlatScreenState extends State<AlatScreen> {
  List<Alat> alats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlats();
  }

  Future<void> fetchAlats() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/alat/'),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          alats = data.map((json) => Alat.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          alats = [];
        });
      }
    } catch (e) {
      print("Error fetching alats: $e");
      setState(() {
        isLoading = false;
        alats = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Alat', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: alats.isEmpty
                  ? const Center(
                      child: Text('Tidak ada alat tersedia',
                          style: TextStyle(color: Colors.white)),
                    )
                  : ListView.builder(
                      itemCount: alats.length,
                      itemBuilder: (context, index) {
                        final alat = alats[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AlatDetailScreen(alat: alat),
                            ),
                          ),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.asset(
                                      alat.imageUrl,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    alat.nameAlat,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    alat.deskripsi,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Stok Terkini: ${alat.stok}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Harga: ${alat.feeAlat}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Spacer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 158, 95, 0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AlatDetailScreen(alat: alat),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Pesan Sekarang',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
