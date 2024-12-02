import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sembilan_nih/kelas/kelas.dart';
import 'status_kelas.dart';

class DaftarScreen extends StatelessWidget {
  final Kelas kelas;

  const DaftarScreen({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Pesanan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        kelas.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kelas.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text('Trainer: ${kelas.trainer}'),
                          Text('Durasi: ${kelas.duration}'),
                          Text('Hari: ${kelas.day}'),
                          Text('Biaya: ${kelas.fee}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color.fromARGB(255, 252, 241, 230),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Total Harga: ${kelas.fee}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Metode Pembayaran:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: const Color.fromARGB(255, 218, 165, 132),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/icons/dana.jpg',
                                    width: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/ovo.jpg',
                                    width: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/shoppe.jpg',
                                    width: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/gopay.jpg',
                                    width: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: const Color.fromARGB(255, 218, 165, 132),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/icons/mandiri.jpg',
                                    width: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/bni.jpg',
                                    width: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/bri.jpg',
                                    width: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 158, 95, 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRGeneratorScreen(kelas: kelas),
                    ),
                  );
                },
                child: const Text(
                  'Bayar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRGeneratorScreen extends StatelessWidget {
  final Kelas kelas;

  const QRGeneratorScreen({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    String paymentData = 'Nama: ${kelas.name}, Biaya: ${kelas.fee}, Spesialis: ${kelas.trainer}';
    
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
            const Text(
              'Scan QR Code untuk Pembayaran',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: paymentData,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 158, 95, 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatusScreen(kelas: kelas),
                    ),
                  );
                },
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
