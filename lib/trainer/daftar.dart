import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'trainer.dart';
import 'status.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarScreen extends StatefulWidget {
  final Trainer trainer;
  const DaftarScreen({super.key, required this.trainer});

  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  String? selectedDigitalPayment = '-';
  String? selectedBankPayment = '-';

  Future<void> submitOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedInUserId = prefs.getInt('userId');
      final now = DateTime.now();
      final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final orderData = {
        'id_layanan': 4,
        'id_pelanggan': loggedInUserId,
        'biaya_pesanan': widget.trainer.fee,
        'tanggal_pesanan': dateStr,
        'digital_payment': selectedDigitalPayment ?? '-',
        'bank_payment': selectedBankPayment ?? '-',
        'id_trainer': widget.trainer.id,
        'id_alat': null,
        'id_kelas': null,
      };

      print('Submitting order with data: ${jsonEncode(orderData)}');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/pemesanan/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemesanan berhasil!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRGeneratorScreen(trainer: widget.trainer),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        print('Error response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan pemesanan: ${responseData['message']}')),
        );
      }
    } catch (e) {
      print('Error submitting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9E5F00),
        title: const Text(
          'Pesanan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrainerCard(),
            const SizedBox(height: 16),
            _buildPaymentOptions(),
            const Spacer(),
            _buildProceedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerCard() {
    return Card(
      color: Colors.white,
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
                widget.trainer.imageUrl,
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
                    widget.trainer.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('Spesialis: ${widget.trainer.specialization}'),
                  Text('Durasi: ${widget.trainer.duration}'),
                  Text('Hari: ${widget.trainer.day}'),
                  Text('Biaya: ${widget.trainer.fee}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Card(
      color: const Color(0xFFFCFFFF),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Total Harga: ${widget.trainer.fee}'),
            const SizedBox(height: 16),
            _buildDropdown(
              title: 'Pilih Metode Pembayaran Digital:',
              items: ['-', 'Dana', 'Ovo', 'Shopee Pay', 'Gopay'],
              selectedValue: selectedDigitalPayment,
              onChanged: selectedBankPayment == '-' ? (String? newValue) {
                setState(() {
                  selectedDigitalPayment = newValue;
                });
              } : null,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              title: 'Pilih Metode Pembayaran Bank:',
              items: ['-', 'Mandiri', 'BNI', 'BRI'],
              selectedValue: selectedBankPayment,
              onChanged: selectedDigitalPayment == '-' ? (String? newValue) {
                setState(() {
                  selectedBankPayment = newValue;
                });
              } : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: const Color(0xFFDAA584),
          ),
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9E5F00),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          if (selectedDigitalPayment != '-' || selectedBankPayment != '-') {
            submitOrder();
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
    );
  }
}

class QRGeneratorScreen extends StatelessWidget {
  final Trainer trainer;

  const QRGeneratorScreen({super.key, required this.trainer});

  Future<void> submitTransaction(BuildContext context) async {
    try {
      final now = DateTime.now();
      final dateStr1 = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final transactionData = {
        'id_pemesanan': 9,
        'tanggal_transaksi': dateStr1,
        'total_tagihan': trainer.fee,
      };

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/transaksi/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatusScreen(trainer: trainer),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        print('Error response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan transaksi: ${responseData['message']}')),
        );
      }
    } catch (e) {
      print('Error submitting transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String paymentData = 'Nama: ${trainer.name}, Biaya: ${trainer.fee}, Spesialis: ${trainer.specialization}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9E5F00),
        title: const Text(
          'Kode QR',
          style: TextStyle(color: Colors.white),
        ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: QrImageView(
                data: paymentData,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9E5F00),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                submitTransaction(context);
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