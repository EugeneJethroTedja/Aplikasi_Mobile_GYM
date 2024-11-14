import 'package:flutter/material.dart';
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
}

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Trainer> trainers = [
      Trainer(
        name: 'Aaron Panji',
        specialization: 'Aerobic',
        duration: '100 Menit',
        day: 'Rabu',
        fee: 'Rp 800.000',
        imageUrl: 'assets/images/trainer1.png',
      ),
      Trainer(
        name: 'Krisnadewa',
        specialization: 'Menarik Wanita',
        duration: '90 Menit',
        day: 'Kamis',
        fee: 'Rp 140.000',
        imageUrl: 'assets/images/trainer2.jpg',
      ),
      // Add more trainers as needed...
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Trainer', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 158, 95, 0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: trainers.length,
          itemBuilder: (context, index) {
            final trainer = trainers[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerDetailScreen(trainer: trainer),
                  ),
                );
              },
              child: Card(
                color: const Color.fromARGB(255, 252, 241, 230),
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
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Spesialis: ${trainer.specialization}'),
                            Text('Durasi: ${trainer.duration}'),
                            Text('Hari: ${trainer.day}'),
                            Text('Biaya: ${trainer.fee}'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainerDetailScreen(trainer: trainer),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 158, 95, 0),
                        ),
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
