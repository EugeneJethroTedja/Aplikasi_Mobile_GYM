import 'package:flutter/material.dart';
import 'dart:io'; // Untuk File
import 'trainer.dart';
import 'trainer_pdf.dart'; // Import untuk generatePdf()

class StatusScreen extends StatefulWidget {
  final Trainer trainer;

  const StatusScreen({super.key, required this.trainer});

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
            Card(
              color: const Color.fromARGB(255, 252, 241, 230),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Status: $status',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
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
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
                                97900,              // Total harga
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