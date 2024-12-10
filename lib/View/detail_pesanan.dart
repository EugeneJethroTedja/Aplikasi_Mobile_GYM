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
          _buildInfoCard(
            context: context,
            image: const AssetImage('assets/images/trainer.jpg'),
            title: 'Detail Trainer',
            subtitle: 'Lihat Trainer Anda',
            routeName: '/histori',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context: context,
            image: const AssetImage('assets/images/alat.jpg'),
            title: 'Detail Alat',
            subtitle: 'Lihat Alat yang Anda Pesan',
            routeName: '/history_alat',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context: context,
            image: const AssetImage('assets/images/kelas.jpeg'),
            title: 'Detail Kelas',
            subtitle: 'Lihat Kelas yang Anda Ikuti',
            routeName: '/history_kelas',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required ImageProvider image,
    required String title,
    required String subtitle,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: image,
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
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detail Pesanan',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DetailPesananPage(),
        '/history_trainer': (context) => TrainerPage(),
        '/history_alat': (context) => AlatPage(),
        '/history_kelas': (context) => KelasPage(),
      },
    );
  }
}
