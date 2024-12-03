import 'package:flutter/material.dart';
import 'dart:io'; // Untuk File
import 'kelas.dart';
import 'kelas_pdf.dart'; // Import untuk generatePdf()

class StatusScreen extends StatefulWidget {
  final Kelas kelas;

  const StatusScreen({super.key, required this.kelas});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String status = 'pending';

  // Simulasi produk yang dijual (bisa dimodifikasi sesuai kebutuhan)
  final List<List<String>> soldProducts = [
    ["Kelas Full Sixpack", "1", "90", "Rp 89.000,00"],
  ];

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
            // Logo di atas
            Image.asset(
              'assets/images/LOGO.png',
              width: 350,
              height: 100,
              fit: BoxFit.contain, // Menampilkan gambar secara proporsional
            ),
            const SizedBox(height: 16),
            Card(
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
                              await generatePdf(
                                context,
                                soldProducts,         // Produk yang dijual
                                "123456789",          // ID Transaksi
                                "Shopeepay",          // Metode pembayaran
                                97900,                // Total harga
                                'assets/images/LOGO.png', // Path logo
                              );
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
