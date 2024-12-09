import 'package:flutter/material.dart';
import 'package:sembilan_nih/list/list_trainer.dart';
import 'package:sembilan_nih/list/list_alat.dart';
import 'package:sembilan_nih/list/list_kelas.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainerPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            context,
            'Detail Alat',
            'Lihat Alat yang Anda Pesan',
            'assets/images/alat.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlatPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            context,
            'Detail Kelas',
            'Lihat Kelas yang Anda Ikuti',
            'assets/images/kelas.jpeg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KelasPage(),
                ),
              );
            },
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
    {VoidCallback? onTap}
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
        // onTap: onTap
        onTap: onTap,
      ),
    );
  }
}
