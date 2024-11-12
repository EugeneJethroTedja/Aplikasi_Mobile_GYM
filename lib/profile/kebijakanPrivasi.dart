import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCD853F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: Text(
                'Kebijakan Privasi Aplikasi EGO GYM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Kami menghargai privasi Anda dan berkomitmen untuk melindungi informasi pribadi yang Anda berikan saat menggunakan aplikasi gym kami. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              '1. Informasi yang Kami Kumpulkan\nKami dapat mengumpulkan informasi berikut dari pengguna aplikasi:\n\n'
              'Informasi Pribadi: Nama, alamat email, nomor telepon, tanggal lahir, jenis kelamin, dan informasi lain yang Anda berikan saat mendaftar.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              '2. Bagaimana Kami Melindungi Informasi Anda\n'
              'Kami menggunakan langkah-langkah keamanan teknis dan organisasi yang sesuai untuk melindungi informasi pribadi Anda dari akses, pengungkapan, atau penggunaan yang tidak sah. Ini termasuk enkripsi data, firewall, dan kontrol akses yang ketat.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              '3. Hak Anda\nSebagai pengguna, Anda memiliki beberapa hak terkait data pribadi Anda, antara lain:',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              '• Akses dan Koreksi: Anda berhak mengakses informasi pribadi yang kami simpan tentang Anda. Anda juga dapat memperbaiki atau memperbarui informasi tersebut jika terdapat kesalahan atau perubahan.',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              '4. Hubungi Kami\nJika Anda memiliki pertanyaan atau kekhawatiran tentang Kebijakan Privasi ini, Anda dapat menghubungi kami di:\n\n'
              'Email: Egogym@gmail.com\n'
              'Telepon: 085159088506',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
