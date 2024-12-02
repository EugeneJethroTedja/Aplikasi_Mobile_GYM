import 'package:flutter/material.dart';

class InformasiPenggunaScreen extends StatelessWidget {
  const InformasiPenggunaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, size: 45, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nama Pengguna',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Email Pengguna',
                  style: TextStyle(
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
                  _buildInfoItem(icon: Icons.person, label: 'Username : Nama Pengguna'),
                  _buildInfoItem(icon: Icons.email, label: 'Email : Email Pengguna'),
                  _buildInfoItem(icon: Icons.phone, label: 'No Telp : 082134538271'),
                  _buildInfoItem(icon: Icons.location_on, label: 'Alamat : Alamat Pengguna'),
                  _buildInfoItem(icon: Icons.person, label: 'Jenis Kelamin : Laki - laki'),
                  _buildInfoItem(icon: Icons.height, label: 'Tinggi badan : 198 cm'),
                  _buildInfoItem(icon: Icons.monitor_weight, label: 'Berat badan : 87 kg'),
                  _buildInfoItem(icon: Icons.cake, label: 'Usia : 70 tahun'),
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
