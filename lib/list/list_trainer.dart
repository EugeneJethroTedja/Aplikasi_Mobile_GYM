import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Trainer {
  final String name;
  final String specialty;
  final String date;
  final int price;
  final String imagePath;
  int? review;

  Trainer({
    required this.name,
    required this.specialty,
    required this.date,
    required this.price,
    required this.imagePath,
    this.review,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      name: json['nama_trainer'] ?? '',
      specialty: json['spesialis'] ?? '',
      date: json['tanggal'] ?? '',
      price: json['biaya'] ?? 0,
      imagePath: json['imageUrl'] ?? 'assets/images/Trainer/default.png',
      review: json['review'] != null ? int.tryParse(json['review'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama_trainer": name,
      "spesialis": specialty,
      "tanggal": date,
      "biaya": price,
      "imageUrl": imagePath,
      "review": review,
    };
  }
}

class TrainerPage extends StatefulWidget {
  const TrainerPage({super.key});

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  List<Trainer> trainers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrainers();
  }

  Future<void> fetchTrainers() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/history_trainer/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          trainers = data.map((json) => Trainer.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  // void updateTrainerReview(String trainerName, int review) {
  //   setState(() {
  //     // Cari trainer berdasarkan nama
  //     final trainer = trainers.firstWhere(
  //       (t) => t['name'] == trainerName,
  //       orElse: () => null,
  //     );
      
  //     if (trainer != null) {
  //       trainer['review'] = review; // Update nilai review
  //     }
  //   });
  // }


  void updateTrainerReview(String trainerName, int review) {
    setState(() {
      final trainer = trainers.firstWhere((t) => t.name == trainerName);
      // final trainer = trainers.firstWhere((t) => t.name == trainerName, orElse: () => null);
      if (trainer.review == null) {
        trainer.review = review;
      }
    });
  }

  // void updateTrainerReview(String trainerName, int review) {
  //   setState(() {
  //     final trainer = trainers.firstWhere((t) => t.name == trainerName, orElse: () => null);
  //     if (trainer != null) {
  //       trainer.review = review;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Trainer Anda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : trainers.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada trainer tersedia',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: trainers.map((trainer) {
                      return _buildTrainerCard(
                        trainer,
                        onReviewUpdate: (rating) {
                          updateTrainerReview(trainer.name, rating);
                        },
                      );
                    }).toList(),
                  ),
                ),
    );
  }

  Widget _buildTrainerCard(Trainer trainer, {required Function(int) onReviewUpdate}) {
    String formattedPrice = NumberFormat('#,###', 'id_ID').format(trainer.price);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    trainer.imagePath,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Spesialisasi: ${trainer.specialty}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Tanggal: ${trainer.date}",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        "Harga: Rp. $formattedPrice",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      if (trainer.review != null)
                        Text(
                          "Review: ${trainer.review}/5",
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1.2, color: Colors.black54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (trainer.review != null)
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 5),
                      Text(
                        "Selesai",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            trainer: trainer,
                            onReviewSubmitted: onReviewUpdate,
                          ),
                        ),
                      );
                    },
                    child: const Text('Review'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewPage extends StatelessWidget {
  final Trainer trainer;
  final Function(int) onReviewSubmitted;

  const ReviewPage({Key? key, required this.trainer, required this.onReviewSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedRating = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Trainer"),
      ),
      body: Column(
        children: [
          Text("Rating untuk ${trainer.name}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  selectedRating = index + 1;
                  onReviewSubmitted(selectedRating);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.star,
                  color: index < selectedRating ? Colors.amber : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
