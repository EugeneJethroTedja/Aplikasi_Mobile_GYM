import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sembilan_nih/trainer/trainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainerPage extends StatefulWidget {
  const TrainerPage({Key? key}) : super(key: key);

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class TrainerSummary {
  final String name;
  final double fee;
  final String transactionDate;
  final String imageUrl;

  TrainerSummary(
      {required this.name, required this.fee, required this.transactionDate, required this.imageUrl});

  // Factory method untuk membuat TrainerSummary dari data JSON
  factory TrainerSummary.fromJson(Map<String, dynamic> json) {
    return TrainerSummary(
      name: json['pelanggan']['nama_pelanggan'] ?? 'Nama Tidak Tersedia',
      fee: json['transaksi']['total_tagihan']?.toDouble() ?? 0.0,
      transactionDate: json['transaksi']['tanggal_transaksi'] ?? 'Tanggal Tidak Tersedia',
      imageUrl: json['pelanggan']['profile_picture'] ?? 'foto tidak ditemukan',
    );
  }
}

class _TrainerPageState extends State<TrainerPage> {
  List<TrainerSummary> trainers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrainers();
    loadHistoryData();
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
        fetchTrainers();
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

  Future<void> fetchTrainers() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/histori/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print(response.body); // Debugging untuk melihat respons

        setState(() {
          // Hanya memetakan data yang diperlukan
          trainers = data.map((json) {
            return TrainerSummary.fromJson(json);
          }).toList();
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

  Future<void> updateTrainerReviewOnServer(int idTransaksi, int review) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/histori/update/$idTransaksi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'review': review}), // Kirim hanya review
      );

      if (response.statusCode == 200) {
        debugPrint('Review updated successfully.');
      } else {
        debugPrint(
            'Failed to update review: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  void updateTrainerReview(int idHistori, int review) async {
    try {
      // Temukan idTransaksi berdasarkan idHistori
      final idTransaksi = await getIdTransaksiByHistori(idHistori);

      // Cek apakah idTransaksi ditemukan
      if (idTransaksi == 0) {
        debugPrint('Transaksi not found for idHistori: $idHistori');
        return;
      }

      // Kirim permintaan untuk memperbarui review ke server
      await updateTrainerReviewOnServer(idTransaksi, review);

      // Jika server berhasil mengupdate, Anda bisa memperbarui UI secara lokal
      // Misalnya, jika Anda ingin menampilkan perubahan, Anda bisa melakukannya di sini

      setState(() {
        // Jika Anda perlu memperbarui UI setelah review berhasil diupdate,
        // Anda bisa mengubah nilai review secara langsung di trainer yang sesuai.
        // Misalnya, Anda bisa menggunakan metode untuk mengupdate nilai review dalam daftar trainers.
      });
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  // Fungsi untuk mendapatkan idTransaksi berdasarkan idHistori
  Future<int> getIdTransaksiByHistori(int idHistori) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/transaksi/$idHistori'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['id_transaksi']; // Mengembalikan id_transaksi
      } else {
        debugPrint('Failed to fetch idTransaksi: ${response.statusCode}');
        return 0; // Kembalikan 0 jika tidak ditemukan
      }
    } catch (e) {
      debugPrint('Error fetching idTransaksi: $e');
      return 0; // Kembalikan 0 jika terjadi kesalahan
    }
  }

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
              : ListView.builder(
                  itemCount: trainers.length,
                  itemBuilder: (context, index) {
                    final trainerSummary =
                        trainers[index]; // Pastikan ini adalah TrainerSummary
                    return _buildTrainerCard(
                        trainerSummary); // Kirim TrainerSummary, bukan Trainer
                  },
                ),
    );
  }

  Widget _buildTrainerCard(TrainerSummary trainerSummary) {
    // Format biaya agar lebih mudah dibaca (misal: 10.000 -> 10.000)
    String formattedPrice =
        NumberFormat('#,###', 'id_ID').format(trainerSummary.fee);

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
                    'assets/images/default_trainer.png', // Gambar default jika tidak ada gambar trainer
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
                        trainerSummary.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Tanggal Transaksi: ${trainerSummary.transactionDate}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Harga: Rp. $formattedPrice",
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
          ],
        ),
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  final TrainerSummary trainerSummary; // Ubah ini menjadi TrainerSummary
  final Function(int) onReviewSubmitted;

  const ReviewPage(
      {Key? key, required this.trainerSummary, required this.onReviewSubmitted})
      : super(key: key);

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
                          widget.trainerSummary.imageUrl,
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
                              widget.trainerSummary.name,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Spesialis: ${widget.trainerSummary.name}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Tanggal  : ${widget.trainerSummary.transactionDate}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Harga     : Rp. ${widget.trainerSummary.fee}",
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
                        "Rating: ",
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
                      backgroundColor: const Color.fromARGB(255, 207, 129, 12),
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