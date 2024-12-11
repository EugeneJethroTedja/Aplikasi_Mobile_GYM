import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'alat.dart';
import 'alat_pdf.dart';
import 'daftarAlat.dart';

class StatusScreen extends StatefulWidget {
  final Alat alat;
  final String dateStr;

  const StatusScreen({super.key, required this.alat, required this.dateStr});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String status = 'pending';
  late List<List<String>> soldProducts;
  String paymentMethod = '';
  bool isLoading = true;
  // String dateStr = '';

  @override
  void initState() {
    super.initState();
    soldProducts = [
      [
        widget.alat.nameAlat,
        '1',
        widget.alat.stok.toString(),
        'Rp ${widget.alat.feeAlat.toStringAsFixed(0)}',
      ],
    ];
    fetchPaymentMethod();
  }

  Future<void> fetchPaymentMethod() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/pemesanan/show/${widget.dateStr}'),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print("Response JSON: $data");

        if (data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
          var orderData = data['data'][0];  

          // Prioritaskan digital_payment terlebih dahulu
          if (orderData.containsKey('digital_payment') && orderData['digital_payment'] != null && orderData['digital_payment'] != '-' && orderData['digital_payment'] != '') {
            setState(() {
              paymentMethod = orderData['digital_payment'];
              isLoading = false;
            });
          } else if (orderData.containsKey('bank_payment') && orderData['bank_payment'] != null) {
            setState(() {
              paymentMethod = orderData['bank_payment'];
              isLoading = false;
            });
          } else {
            setState(() {
              paymentMethod = 'Metode pembayaran tidak ditemukan';
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
            paymentMethod = 'Data pemesanan tidak ditemukan';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          paymentMethod = 'Metode pembayaran tidak ditemukan ya';
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
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Status: $status',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
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
                              backgroundColor:
                                  const Color.fromARGB(255, 158, 95, 0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () async {
                              print('Products: $soldProducts');
                              await generatePdf(
                                context,
                                soldProducts,
                                widget.alat.id.toString(),
                                paymentMethod,
                                widget.alat.feeAlat,
                                'assets/images/LOGO.png',
                              );
                            },
                            child: const Text(
                              'Cetak PDF',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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