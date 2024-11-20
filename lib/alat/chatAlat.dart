import 'package:flutter/material.dart';
import 'package:sembilan_nih/alat/alat.dart';

class ChatScreen extends StatelessWidget {
  final Alat alat;

  const ChatScreen({super.key, required this.alat});

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
              alat.nameAlat,
              "Selamat Pagi/Siang/Sore/Malam ada yang bisa saya bantu?",
              true,
              alat.imageUrl),
          buildMessageBubble(
              "Ilha,",
              "Saya ingin menyewa alat gym, bagaimana caranya?",
              false,
              'assets/images/mbappe.jpg'),
          buildMessageBubble(
              alat.nameAlat,
              "Selamat Pagi/Siang/Sore, kakak bisa langsung pesan saja untuk menyewa alat gym dari kami sesuai dengan keinginan kaka.",
              true,
              alat.imageUrl),
          buildMessageBubble(
              "Ilham",
              "Baik kak, terima kasih untuk informasinya.",
              false,
              'assets/images/mbappe.jpg'),
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
          if (!isSender)
            const SizedBox(width: 8.0), // Tambahkan spasi di sisi kiri pesan
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
