import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alat.dart';
import 'statusAlat.dart';

class DaftarScreen extends StatefulWidget {
  final Alat alat;

  const DaftarScreen({super.key, required this.alat});

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
      final dateStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      await prefs.setString('dateStr', dateStr);

      final orderData = {
        'id_layanan': 5,
        'id_pelanggan': loggedInUserId,
        'biaya_pesanan': widget.alat.feeAlat,
        'tanggal_pesanan': dateStr,
        'digital_payment': selectedDigitalPayment ?? '-',
        'bank_payment': selectedBankPayment ?? '-',
        'id_trainer': null,
        'id_alat': widget.alat.id,
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
            builder: (context) => QRGeneratorScreen(
              alat: widget.alat,
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
                  'Gagal menyimpan pemesanan: ${responseData['message']}')),
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
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Pesanan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color.fromARGB(255, 255, 255, 255),
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
                        widget.alat.imageUrl,
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
                            widget.alat.nameAlat,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text('${widget.alat.deskripsi}'),
                          const SizedBox(height: 8),
                          Text(
                            'Stok: ${widget.alat.stok}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Harga: ${widget.alat.feeAlat}',
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
              color: const Color.fromARGB(255, 255, 255, 255),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text('Total Harga: ${widget.alat.feeAlat}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Metode Pembayaran Digital: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
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
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Metode Pembayaran Bank: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
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
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 95, 0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: () {
                      if (selectedDigitalPayment != '-' ||
                          selectedBankPayment != '-') {
                        submitOrder();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Harap pilih metode pembayaran.')),
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
  final Alat alat;
  final String dateStr;

  const QRGeneratorScreen({Key? key, required this.alat, required this.dateStr}) : super(key: key);

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
          'total_tagihan': alat.feeAlat,
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
              builder: (context) => StatusScreen(alat: alat, dateStr: dateStr),
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
        'Nama: ${alat.nameAlat}, Biaya: ${alat.feeAlat}, Deskripsi: ${alat.deskripsi}';

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