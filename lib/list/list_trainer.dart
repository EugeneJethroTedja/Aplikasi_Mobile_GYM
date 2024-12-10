import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trainer {
  final int idHistori;
  final String name;
  final String specialty;
  final String date;
  final String jenis;
  final double price;
  final String imagePath;
  int? review;

  Trainer({
    required this.idHistori,
    required this.name,
    required this.specialty,
    required this.date,
    required this.jenis,
    required this.price,
    required this.imagePath,
    this.review,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      idHistori: json['id_histori'],
      name: json['nama'] ?? '',
      specialty: json['spesialis'] ?? '',
      date: json['tanggal'] ?? '',
      jenis: json['jenis'] ?? '',
      price: (json['harga'] ?? 0).toDouble(),
      imagePath: json['imageUrl'] ?? 'assets/images/Trainer/default.png',
      review: json['review'] != null ? int.tryParse(json['review'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_histori": idHistori,
      "nama": name,
      "spesialis": specialty,
      "tanggal": date,
      "jenis": jenis,
      "harga": price,
      "imageUrl": imagePath,
      "review": review,
    };
  }
}

Future<void> createHistory(int loggedInUserId, int transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/histori/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'review': 0,
          'id_transaksi': transactionId,
          'id_pelanggan': loggedInUserId,
        }),
      );

      if (response.statusCode == 201) {
        debugPrint('History created successfully.');
      } else {
        debugPrint(
            'Failed to create history: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error creating history: $e');
    }
  }

  Future<void> loadHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getInt('orderId');
    final transactionId = prefs.getInt('transactionId');
    final trainerId = prefs.getInt('trainerId');
    final loggedInUserId = prefs.getInt('userId');
    print(orderId);
    print(transactionId);
    print(trainerId);
    print(loggedInUserId);
    if (loggedInUserId != null &&
        orderId != null &&
        transactionId != null &&
        trainerId != null) {
      print('Order ID: $orderId');
      print('Transaction ID: $transactionId');
      print('Trainer ID: $trainerId');
      print('User ID: $loggedInUserId');

      await createHistory(loggedInUserId, transactionId);
    } else {
      print('Data tidak ditemukan');
    }
  }

class TrainerPage extends StatefulWidget {
  const TrainerPage({Key? key}) : super(key: key);

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
    loadHistoryData();
  }

  Future<void> fetchTrainers() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/histori/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          trainers = data.map((json) => Trainer.fromJson(json)).toList();
        });
      } else {
        debugPrint('Failed to load trainers: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching trainers: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateTrainerReviewOnServer(int idHistori, int review) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/histori/update/$idHistori'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'review': review}), // Kirim hanya `review`
      );

      if (response.statusCode == 200) {
        debugPrint('Review updated successfully.');
      } else {
        debugPrint('Failed to update review: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  void updateTrainerReview(int idHistori, int review) async {
    try {
      // Temukan trainer berdasarkan `idHistori`
      final trainer = trainers.firstWhere((t) => t.idHistori == idHistori);

      // Simpan nilai asli untuk rollback jika gagal
      final originalReview = trainer.review;

      // Perbarui UI secara lokal
      setState(() {
        trainer.review = review;
      });

      // Kirim permintaan ke server
      await updateTrainerReviewOnServer(idHistori, review);
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter trainers untuk hanya menampilkan data dengan jenis 'trainer'
    List<Trainer> filteredTrainers =
        trainers.where((trainer) => trainer.jenis == 'trainer').toList();

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
          : filteredTrainers.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada trainer tersedia',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredTrainers.length,
                  itemBuilder: (context, index) {
                    final trainer = filteredTrainers[index];
                    return _buildTrainerCard(
                      trainer,
                      onReviewUpdate: (rating) {
                        updateTrainerReview(trainer.idHistori, rating);
                      },
                    );
                  },
                ),
    );
  }


  // @override
  // Widget build(BuildContext context) {

  //   // utk filter trainers untuk hanya menampilkan data dengan jenis 'trainer' SAJa
  // List<Trainer> filteredTrainers =
  //     trainers.where((trainer) => trainer.jenis == 'trainer').toList();

  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     appBar: AppBar(
  //       backgroundColor: const Color.fromARGB(255, 158, 95, 0),
  //       title: const Text('Trainer Anda'),
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : filteredTrainers.isEmpty
  //             ? const Center(
  //                 child: Text(
  //                   'Tidak ada trainer tersedia',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               )
  //             : ListView.builder(
  //                 itemCount: trainers.length,
  //                 itemBuilder: (context, index) {
  //                   final trainer = trainers[index];
  //                   return _buildTrainerCard(
  //                     trainer,
  //                     onReviewUpdate: (rating) {
  //                       updateTrainerReview(trainer.idHistori, rating);
  //                     },
  //                   );
  //                 },
  //               ),
  //   );
  // }

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
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Tanggal: ${trainer.date}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      Text(
                        "Harga: Rp. $formattedPrice",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      if (trainer.review != null)
                        Text(
                          "Review: ${trainer.review}/5",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
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
                  Text('Berlaku Hingga ${trainer.date}', style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    )),
                    const SizedBox(height: 10),
                if (trainer.review == null)
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 207, 129, 12), // Warna tombol
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 14.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  final Trainer trainer;
  final Function(int) onReviewSubmitted;

  const ReviewPage({Key? key, required this.trainer, required this.onReviewSubmitted}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text("Review Trainer"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
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
                            widget.trainer.imagePath,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 19),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.trainer.name,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Spesialis: ${widget.trainer.specialty}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Tanggal  : ${widget.trainer.date}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Harga     : Rp. ${widget.trainer.price}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(thickness: 1.5, color: Colors.black38),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Rating:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedRating = index + 1;
                                });
                              },
                              icon: Icon(
                                Icons.star,
                                color: index < selectedRating
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        widget.onReviewSubmitted(selectedRating);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 207, 129, 12), // ini Warna tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Kirim',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}