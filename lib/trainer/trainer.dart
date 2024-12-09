import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'trainer_detail.dart';

class Trainer {
  final int id;
  final int idLayanan;
  final int idPelanggan;
  final String name;
  final String specialization;
  final int duration;
  final String day;
  final int fee;
  final String imageUrl;

  Trainer({
    required this.id,
    required this.idLayanan,
    required this.idPelanggan,
    required this.name,
    required this.specialization,
    required this.duration,
    required this.day,
    required this.fee,
    required this.imageUrl,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id_trainer'] ?? 0,
      idLayanan: json['id_layanan'] ?? 0,
      idPelanggan: json['id_pelanggan'] ?? 0,
      name: json['nama_trainer'] ?? '',
      specialization: json['spesialis'] ?? '',
      duration: json['durasi'] ?? '',
      day: json['tanggal'] ?? '',
      fee: json['biaya'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/trainer1.png',
    );
  }
}

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  List<Trainer> trainers = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchTrainers();
  }

  Future<void> fetchTrainers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/trainer/'),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          trainers = data.map((json) => Trainer.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          trainers = [];
        });
      }
    } catch (e) {
      print("Error fetching trainers: $e");
      setState(() {
        isLoading = false;
        trainers = [];
      });
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
    } else {
      Navigator.of(context).pushNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Trainer', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: trainers.isEmpty
                  ? const Center(
                      child: Text('Tidak ada trainer tersedia',
                          style: TextStyle(color: Colors.white)),
                    )
                  : ListView.builder(
                      itemCount: trainers.length,
                      itemBuilder: (context, index) {
                        final trainer = trainers[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TrainerDetailScreen(trainer: trainer),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Image.asset(
                                        trainer.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trainer.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                            'Spesialis: ${trainer.specialization}',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        Text('Durasi: ${trainer.duration}',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        Text('Hari: ${trainer.day}',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        Text('Biaya: ${trainer.fee}',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TrainerDetailScreen(
                                                trainer: trainer),
                                      ),
                                    ),
                                    icon: const Icon(Icons.arrow_forward,
                                        color: Color.fromARGB(255, 158, 95, 0)),
                                  ),
                                ],
                              ),
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
