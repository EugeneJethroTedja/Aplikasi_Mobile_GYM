import 'package:flutter/material.dart';
import 'package:sembilan_nih/kelas/kelas.dart';

class ChatScreen extends StatelessWidget {
  final Kelas kelas;

  const ChatScreen({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 158, 95, 0),
        title: const Text('Room Chat', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildMessageBubble(
              kelas.name,
              "Selamat Pagi/Siang/Sore/Malam ada yang bisa saya bantu?",
              true,
              kelas.imageUrl),
          buildMessageBubble("Putra", "Saya ingin mendaftar kelas kak, caranya bagaimana ya?",
              false, 'assets/images/user.png'),
          buildMessageBubble(
              kelas.name,
              "Kakak bisa langsung pencet daftar saja untuk mendapatkan kelas buruan keburu kehabisan.",
              true,
              kelas.imageUrl),
          buildMessageBubble("Putra", "Baik kak, terima kasih untuk informasinya, langsung kalo ini mah wkwk.",
              false, 'assets/images/user.png'),
        ],
      ),
    );
  }

  Widget buildMessageBubble(
      String sender, String message, bool isSender, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isSender) // Avatar hanya untuk pengirim
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          if (!isSender) const SizedBox(width: 8.0), // Tambahkan spasi di sisi kiri pesan
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    sender,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(message),
                ],
              ),
            ),
          ),
          if (!isSender) // Avatar hanya untuk penerima
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}