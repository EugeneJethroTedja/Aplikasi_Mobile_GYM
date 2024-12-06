import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InformasiPenggunaScreen extends StatefulWidget {
  final int? userId;

  const InformasiPenggunaScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<InformasiPenggunaScreen> createState() =>
      _InformasiPenggunaScreenState();
}

class _InformasiPenggunaScreenState extends State<InformasiPenggunaScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    validateAndFetchUserData();
  }

Future<void> validateAndFetchUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserId = prefs.getInt('userId');

    if (loggedInUserId == null) {
      throw Exception('ID pengguna tidak ditemukan di session.');
    }

    if (widget.userId != null && widget.userId != loggedInUserId) {
      throw Exception('Akses ditolak. ID tidak sesuai.');
    }

    final userId = widget.userId ?? loggedInUserId;
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/pelanggan/$userId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body)['data'];
        isLoading = false;
      });
    } else {
      throw Exception('Gagal mengambil data pengguna');
    }
  } catch (e) {
    setState(() {
      userData = {'error': e.toString()};
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null || userData!.containsKey('error')) {
      return Scaffold(
        body: Center(
          child: Text(userData?['error'] ?? 'Error'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFCD853F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 28,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  userData!['username'] ?? 'Nama Pengguna',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData!['email_pelanggan'] ?? 'Email Pengguna',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoItem(
                    icon: Icons.person,
                    label: 'Username : ${userData!['username'] ?? 'Nama Pengguna'}',
                  ),
                  _buildInfoItem(
                    icon: Icons.email,
                    label: 'Email : ${userData!['email_pelanggan'] ?? 'Email Pengguna'}',
                  ),
                  _buildInfoItem(
                    icon: Icons.phone,
                    label: 'No Telp : ${userData!['noTelp_pelanggan']?.toString() ?? 'Tidak tersedia'}',
                  ),
                  _buildInfoItem(
                    icon: Icons.location_on,
                    label: 'Alamat : ${userData!['alamat'] ?? 'Alamat Pengguna'}',
                  ),
                  _buildInfoItem(
                    icon: Icons.person,
                    label: 'Jenis Kelamin : ${userData!['gender'] ?? 'Laki - laki'}',
                  ),
                  _buildInfoItem(
                    icon: Icons.height,
                    label: 'Tinggi badan : ${userData!['tinggi_badan']?.toString() ?? '0'} cm',
                  ),
                  _buildInfoItem(
                    icon: Icons.monitor_weight,
                    label: 'Berat badan : ${userData!['berat_badan']?.toString() ?? '0'} kg',
                  ),
                  _buildInfoItem(
                    icon: Icons.cake,
                    label: 'Usia : ${userData!['umur_pelanggan']?.toString() ?? '0'} tahun',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
