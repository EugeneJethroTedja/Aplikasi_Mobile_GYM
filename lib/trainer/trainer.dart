import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'trainer_detail.dart';

class Trainer {
  final String name;
  final String specialization;
  final String duration;
  final String day;
  final String fee;
  final String imageUrl;

  Trainer({
    required this.name,
    required this.specialization,
    required this.duration,
    required this.day,
    required this.fee,
    required this.imageUrl,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      name: json['nama_trainer'] ?? '',
      specialization: json['spesialis'] ?? '',
      duration: json['durasi'] ?? '',
      day: json['hari'] ?? '',
      fee: json['biaya'] ?? '',
      imageUrl: json['image_url'] ?? 'assets/images/trainer1.png',
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

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          trainers = data.map((json) => Trainer.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
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
                          builder: (context) => TrainerDetailScreen(trainer: trainer),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trainer.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('Spesialis: ${trainer.specialization}',
                                      style: const TextStyle(color: Colors.black)),
                                    Text('Durasi: ${trainer.duration}',
                                      style: const TextStyle(color: Colors.black)),
                                    Text('Hari: ${trainer.day}',
                                      style: const TextStyle(color: Colors.black)),
                                    Text('Biaya: ${trainer.fee}',
                                      style: const TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrainerDetailScreen(trainer: trainer),
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
    );
  }
}