import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Kelas {
  final int idHistori;
  final String name;
  final String specialty;
  final String date;
  final String jenis;
  final double price;
  final String imagePath;
  int? review;

  Kelas({
    required this.idHistori,
    required this.name,
    required this.specialty,
    required this.date,
    required this.jenis,
    required this.price,
    required this.imagePath,
    this.review,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      idHistori: json['id_histori'],
      name: json['nama'] ?? '',
      specialty: json['spesialis'] ?? '',
      date: json['tanggal'] ?? '',
      jenis: json['jenis'] ?? '',
      price: (json['harga'] ?? 0).toDouble(),
      imagePath: json['imageUrl'] ?? 'assets/images/Kelas/default.png',
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

class KelasPage extends StatefulWidget {
  const KelasPage({Key? key}) : super(key: key);

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  List<Kelas> trainers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKelass();
  }

  Future<void> fetchKelass() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/histori/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          trainers = data.map((json) => Kelas.fromJson(json)).toList();
        });
      } else {
        debugPrint('Failed to load kelass: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching kelass: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateKelasReviewOnServer(int idHistori, int review) async {
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

  void updateKelasReview(int idHistori, int review) async {
    try {
      // Temukan Kelas berdasarkan `idHistori`
      final kelas = trainers.firstWhere((t) => t.idHistori == idHistori);

      // Simpan nilai asli untuk rollback jika gagal
      final originalReview = kelas.review;

      // Perbarui UI secara lokal
      setState(() {
        kelas.review = review;
      });

      // Kirim permintaan ke server
      await updateKelasReviewOnServer(idHistori, review);
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  // Filter trainers untuk hanya menampilkan data dengan jenis 'trainer'
  List<Kelas> filteredKelas =
      trainers.where((kelas) => kelas.jenis == 'kelas').toList();

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 158, 95, 0),
      title: const Text('Kelas Anda'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredKelas.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada trainer tersedia',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: filteredKelas.length,
                itemBuilder: (context, index) {
                  final trainer = filteredKelas[index];
                  return _buildKelasCard(
                    trainer,
                    onReviewUpdate: (rating) {
                      updateKelasReview(trainer.idHistori, rating);
                    },
                  );
                },
              ),
  );
}


  Widget _buildKelasCard(Kelas kelas, {required Function(int) onReviewUpdate}) {
    String formattedPrice = NumberFormat('#,###', 'id_ID').format(kelas.price);

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
                    kelas.imagePath,
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
                        kelas.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Trainer  : ${kelas.specialty}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Tanggal: ${kelas.date}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      Text(
                        "Harga: Rp. $formattedPrice",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      if (kelas.review != null)
                        Text(
                          "Review: ${kelas.review}/5",
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
                if (kelas.review != null)
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
                  Text('Berlaku Hingga ${kelas.date}', style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    )),
                    const SizedBox(height: 10),
                if (kelas.review == null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            kelas: kelas,
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
  final Kelas kelas;
  final Function(int) onReviewSubmitted;

  const ReviewPage({Key? key, required this.kelas, required this.onReviewSubmitted}) : super(key: key);

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
        title: const Text("Review Kelas"),
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
                            widget.kelas.imagePath,
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
                                widget.kelas.name,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Spesialis: ${widget.kelas.specialty}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Tanggal  : ${widget.kelas.date}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Harga     : Rp. ${widget.kelas.price}",
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