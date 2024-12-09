import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'trainer.dart'; // Pastikan Trainer class didefinisikan dengan benar
import 'trainer_pdf.dart'; // Import untuk generatePdf()

class StatusScreen extends StatefulWidget {
  final Trainer trainer;

  const StatusScreen({super.key, required this.trainer});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String status = 'pending';
  late List<List<String>> soldProducts;
  String paymentMethod = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    soldProducts = [
      [
        widget.trainer.name, 
        '1', 
        widget.trainer.duration.toString(), 
        'Rp ${widget.trainer.fee.toStringAsFixed(0)}', 
      ],
    ];
    fetchPaymentMethod();
  }

  Future<void> fetchPaymentMethod() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/pemesanan/show/13'),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Cek apakah 'data' berisi 'bank_payment'
        if (data.containsKey('data') && data['data'].containsKey('bank_payment')) {
          setState(() {
            paymentMethod = data['data']['bank_payment'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            paymentMethod = 'Metode pembayaran tidak ditemukan';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          paymentMethod = 'Metode pembayaran tidak ditemukan';
        });
      }
    } catch (e) {
      print("Error fetching payment method: $e");
      setState(() {
        isLoading = false;
        paymentMethod = 'Error saat mengambil data';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Kode QR', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LOGO.png',
              width: 350,
              height: 100,
              fit: BoxFit.contain, // Menampilkan gambar secara proporsional
            ),
            const SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator() // Menampilkan indikator loading jika data belum ada
                : Card(
                    color: const Color.fromARGB(255, 252, 241, 230),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Teks status
                          Expanded(
                            child: Text(
                              'Status: $status',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          // Ikon atau tombol tergantung status
                          status == 'pending'
                              ? IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () {
                                    setState(() {
                                      status = 'selesai';
                                    });
                                  },
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 158, 95, 0),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Mengambil data dari trainer
                                    String transactionId = "123456789"; // ID transaksi, bisa dinamis
                                    int totalPrice = widget.trainer.fee; // Total biaya sesuai biaya trainer

                                    // Menunggu paymentMethod tersedia
                                    if (paymentMethod.isNotEmpty) {
                                      await generatePdf(
                                        context,
                                        soldProducts,           // Produk yang dijual
                                        transactionId,          // ID Transaksi
                                        paymentMethod,          // Metode pembayaran
                                        totalPrice,             // Total harga
                                        'assets/images/LOGO.png', // Path logo
                                      );
                                    } else {
                                      print('Payment method is not available yet.');
                                    }
                                  },
                                  child: const Text(
                                    'Cetak PDF',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
