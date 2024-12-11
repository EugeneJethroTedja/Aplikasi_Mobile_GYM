import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Alat {
  final int idHistori;
  final String name;
  final String specialty;
  final String date;
  final String jenis;
  final double price;
  final String imagePath;
  int? review;

  Alat({
    required this.idHistori,
    required this.name,
    required this.specialty,
    required this.date,
    required this.jenis,
    required this.price,
    required this.imagePath,
    this.review,
  });

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      idHistori: json['id_histori'],
      name: json['nama'] ?? '',
      specialty: json['spesialis'] ?? '',
      date: json['tanggal'] ?? '',
      jenis: json['jenis'] ?? '',
      price: (json['harga'] ?? 0).toDouble(),
      imagePath: json['imageUrl'] ?? 'assets/images/Alat/default.png',
      review: json['review'] != null ? int.tryParse(json['review'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_histori": idHistori,
      "nama": name,
      "spesialis": specialty,
      "tanggal": date,
      "harga": price,
      "imageUrl": imagePath,
      "review": review,
    };
  }
}

class AlatPage extends StatefulWidget {
  const AlatPage({Key? key}) : super(key: key);

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  List<Alat> trainers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrainers();
  }

  Future<void> fetchTrainers() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/histori/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          trainers = data.map((json) => Alat.fromJson(json)).toList();
        });
      } else {
        debugPrint('Failed to load alats: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching alats: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateAlatReviewOnServer(int idHistori, int review) async {
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

  void updateAlatReview(int idHistori, int review) async {
    try {
      final alat = trainers.firstWhere((t) => t.idHistori == idHistori);

      final originalReview = alat.review;

      setState(() {
        alat.review = review;
      });

      await updateAlatReviewOnServer(idHistori, review);
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Alat> filteredAlats =
        trainers.where((trainer) => trainer.jenis == 'alat').toList();

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
          : filteredAlats.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada trainer tersedia',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredAlats.length,
                  itemBuilder: (context, index) {
                    final trainer = filteredAlats[index];
                    return _buildAlatCard(
                      trainer,
                      onReviewUpdate: (rating) {
                        updateAlatReview(trainer.idHistori, rating);
                      },
                    );
                  },
                ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     appBar: AppBar(
  //       backgroundColor: const Color.fromARGB(255, 158, 95, 0),
  //       title: const Text('Alat Anda'),
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : trainers.isEmpty
  //             ? const Center(
  //                 child: Text(
  //                   'Tidak ada alat tersedia',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               )
  //             : ListView.builder(
  //                 itemCount: trainers.length,
  //                 itemBuilder: (context, index) {
  //                   final alat = trainers[index];
  //                   return _buildAlatCard(
  //                     alat,
  //                     onReviewUpdate: (rating) {
  //                       updateAlatReview(alat.idHistori, rating);
  //                     },
  //                   );
  //                 },
  //               ),
  //   );
  // }

  Widget _buildAlatCard(Alat alat, {required Function(int) onReviewUpdate}) {
    String formattedPrice = NumberFormat('#,###', 'id_ID').format(alat.price);

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
                    alat.imagePath,
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
                        alat.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Spesialisasi: ${alat.specialty}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Tanggal: ${alat.date}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      Text(
                        "Harga: Rp. $formattedPrice",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      if (alat.review != null)
                        Text(
                          "Review: ${alat.review}/5",
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
                if (alat.review != null)
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
                  Text('Berlaku Hingga ${alat.date}', style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    )),
                    const SizedBox(height: 10),
                if (alat.review == null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            alat: alat,
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
  final Alat alat;
  final Function(int) onReviewSubmitted;

  const ReviewPage({Key? key, required this.alat, required this.onReviewSubmitted}) : super(key: key);

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
        title: const Text("Review Alat"),
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
                            widget.alat.imagePath,
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
                                widget.alat.name,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Spesialis: ${widget.alat.specialty}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Tanggal  : ${widget.alat.date}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Harga     : Rp. ${widget.alat.price}",
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