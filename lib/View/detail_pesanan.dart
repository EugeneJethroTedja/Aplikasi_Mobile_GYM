import 'package:flutter/material.dart';

class DetailPesananPage extends StatelessWidget {
  const DetailPesananPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Detail Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDetailCard(
            context,
            'Detail Trainer',
            'Lihat Trainer Anda',
            'assets/images/trainer.jpg',
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            context,
            'Detail Alat',
            'Lihat Alat yang Anda Pesan',
            'assets/images/alat.jpg',
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            context,
            'Detail Kelas',
            'Lihat Kelas yang Anda Ikuti',
            'assets/images/kelas.jpeg',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          // Add
        },
      ),
    );
  }
}
