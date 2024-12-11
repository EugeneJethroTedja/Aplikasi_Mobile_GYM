import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'trainer.dart'; // Pastikan Trainer class didefinisikan dengan benar
import 'trainer_pdf.dart'; // Import untuk generatePdf()

class StatusScreen extends StatefulWidget {
  final Trainer trainer;
  final String dateStr;

  const StatusScreen({super.key, required this.trainer, required this.dateStr});

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
        Uri.parse('http://10.0.2.2:8000/api/pemesanan/show/${widget.dateStr}'),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print("Response JSON: $data");

        if (data.containsKey('data') &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          var orderData = data['data'][0];

          // Cek prioritas metode pembayaran
          if (orderData.containsKey('digital_payment') &&
              orderData['digital_payment'] != null &&
              orderData['digital_payment'].toString().trim().isNotEmpty &&
              orderData['digital_payment'] != '-') {
            setState(() {
              paymentMethod = orderData['digital_payment'];
              isLoading = false;
            });
          } else if (orderData.containsKey('bank_payment') &&
              orderData['bank_payment'] != null &&
              orderData['bank_payment'].toString().trim().isNotEmpty) {
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
            paymentMethod = 'Data pemesanan tidak ditemukan';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          paymentMethod = 'Gagal mengambil metode pembayaran';
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching payment method: $e");
      setState(() {
        paymentMethod = 'Error saat mengambil data';
        isLoading = false;
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
            isLoading
                ? const CircularProgressIndicator()
                : Card(
                    color: const Color.fromARGB(255, 252, 241, 230),
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
                                    if (paymentMethod.isNotEmpty) {
                                      await generatePdf(
                                        context,
                                        soldProducts,
                                        widget.trainer.id.toString(),
                                        paymentMethod,
                                        widget.trainer.fee,
                                        'assets/images/LOGO.png',
                                      );
                                    } else {
                                      print(
                                          'Payment method is not available yet.');
                                    }
                                  },
                                  child: const Text(
                                    'Cetak PDF',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
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