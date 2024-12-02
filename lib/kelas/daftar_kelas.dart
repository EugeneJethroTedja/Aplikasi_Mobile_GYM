import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sembilan_nih/kelas/kelas.dart';
import 'status_kelas.dart';

class DaftarScreen extends StatefulWidget {
  final Kelas kelas;

  const DaftarScreen({super.key, required this.kelas});

  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  String? selectedDigitalPayment = '-';
  String? selectedBankPayment = '-';

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
              color: const Color.fromARGB(255, 252, 255, 255),
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
                        widget.kelas.imageUrl,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.kelas.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text('Trainer: ${widget.kelas.trainer}'),
                          Text('Durasi: ${widget.kelas.duration}'),
                          Text('Hari: ${widget.kelas.day}'),
                          Text(
                            'Biaya: ${widget.kelas.fee}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color.fromARGB(255, 252, 255, 255),
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
                    Text('Total Harga: ${widget.kelas.fee}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Metode Pembayaran Digital:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 218, 165, 132),
                      ),
                      value: selectedDigitalPayment,
                      items: ['-', 'Dana', 'Ovo', 'Shopee Pay', 'Gopay']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: selectedBankPayment == '-'
                          ? (String? newValue) {
                              setState(() {
                                selectedDigitalPayment = newValue;
                              });
                            }
                          : null, // Disable jika bank dipilih
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Metode Pembayaran Bank:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 218, 165, 132),
                      ),
                      value: selectedBankPayment,
                      items: ['-', 'Mandiri', 'BNI', 'BRI'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: selectedDigitalPayment == '-'
                          ? (String? newValue) {
                              setState(() {
                                selectedBankPayment = newValue;
                              });
                            }
                          : null, // Disable jika digital dipilih
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 95, 0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (selectedDigitalPayment != '-' ||
                          selectedBankPayment != '-') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRGeneratorScreen(
                              kelas: widget.kelas,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harap pilih metode pembayaran.'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Bayar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
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
    String paymentData =
        'Nama: ${kelas.name}, Biaya: ${kelas.fee}, Spesialis: ${kelas.trainer}';

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
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: QrImageView(
                  data: paymentData,
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 158, 95, 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
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
          ],
        ),
      ),
    );
  }
}
