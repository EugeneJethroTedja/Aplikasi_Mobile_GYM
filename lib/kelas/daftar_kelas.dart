import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kelas.dart';
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

  Future<void> submitOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedInUserId = prefs.getInt('userId');

      if (loggedInUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda harus login terlebih dahulu.')),
        );
        return;
      }

      final now = DateTime.now();
      final dateStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      await prefs.setString('dateStr', dateStr);

      final orderData = {
        'id_layanan': 6,
        'id_pelanggan': loggedInUserId,
        'biaya_pesanan': widget.kelas.feeKelas,
        'tanggal_pesanan': dateStr,
        'digital_payment': selectedDigitalPayment ?? '-',
        'bank_payment': selectedBankPayment ?? '-',
        'id_trainer': null,
        'id_alat': null,
        'id_kelas': widget.kelas.id,
      };

      print('Submitting order with data: ${jsonEncode(orderData)}');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/pemesanan/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRGeneratorScreen(
              kelas: widget.kelas,
              dateStr: dateStr, 
            ),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        print('Error response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal menyimpan transaksi: ${responseData['message']}')),
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
        title: const Text('Pesanan', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKelasCard(),
            const SizedBox(height: 16),
            _buildPaymentOptions(),
            const Spacer(),
            _buildProceedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildKelasCard() {
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
                    widget.kelas.nameKelas,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('Trainer: ${widget.kelas.trainer}'),
                  Text('Durasi: ${widget.kelas.durationKelas}'),
                  Text('Hari: ${widget.kelas.dayKelas}'),
                  Text('Biaya: ${widget.kelas.feeKelas}'),
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
            Text('Total Harga: ${widget.kelas.feeKelas}'),
            const SizedBox(height: 16),
            _buildDropdown(
              title: 'Pilih Metode Pembayaran Digital:',
              items: ['-', 'Dana', 'Ovo', 'Shopee Pay', 'Gopay'],
              selectedValue: selectedDigitalPayment,
              onChanged: selectedBankPayment == '-'
                  ? (String? newValue) {
                      setState(() {
                        selectedDigitalPayment = newValue;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              title: 'Pilih Metode Pembayaran Bank:',
              items: ['-', 'Mandiri', 'BNI', 'BRI'],
              selectedValue: selectedBankPayment,
              onChanged: selectedDigitalPayment == '-'
                  ? (String? newValue) {
                      setState(() {
                        selectedBankPayment = newValue;
                      });
                    }
                  : null,
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
  final Kelas kelas;
  final String dateStr;

  const QRGeneratorScreen({Key? key, required this.kelas, required this.dateStr}) : super(key: key);

  Future<int?> fetchOrderIdByDate(String dateStr) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/pemesanan/show/$dateStr'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final orderId = responseData['data'][0]['id_pemesanan'];
          return orderId;
        } else {
          print('No orders found for this date.');
          return null;
        }
      } else {
        print('Failed to fetch orders: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching order data: $e');
      return null;
    }
  }

  Future<void> submitTransaction(BuildContext context) async {
    try {
      final orderId = await fetchOrderIdByDate(dateStr);

      if (orderId != null) {
        final transactionData = {
          'id_pemesanan': orderId,
          'tanggal_transaksi': dateStr,
          'total_tagihan': kelas.feeKelas,
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
              builder: (context) => StatusScreen(kelas: kelas, dateStr: dateStr),
            ),
          );
        } else {
          final responseData = json.decode(response.body);
          print('Error response: $responseData');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menyimpan transaksi: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendapatkan ID pemesanan.')),
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
    String paymentData =
        'Nama: ${kelas.nameKelas}, Biaya: ${kelas.feeKelas}, Nama Trainer: ${kelas.trainer}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9E5F00),
        title: const Text(
          'Kode QR Pembayaran',
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
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
