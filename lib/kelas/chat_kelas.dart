import 'package:flutter/material.dart';
import 'package:sembilan_nih/kelas/kelas.dart';

class ChatScreen extends StatefulWidget {
  final Kelas kelas;

  const ChatScreen({super.key, required this.kelas});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/detail_pesanan');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/home');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
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
              widget.kelas.nameKelas,
              "Selamat Pagi/Siang/Sore/Malam ada yang bisa saya bantu?",
              true,
              widget.kelas.imageUrl),
          buildMessageBubble("Putra", "Saya ingin mendaftar kelas kak, caranya bagaimana ya?",
              false, 'assets/images/user.png'),
          buildMessageBubble(
              widget.kelas.nameKelas,
              "Kakak bisa langsung pencet daftar saja untuk mendapatkan kelas buruan keburu kehabisan.",
              true,
              widget.kelas.imageUrl),
          buildMessageBubble("Putra", "Baik kak, terima kasih untuk informasinya, langsung kalo ini mah wkwk.",
              false, 'assets/images/user.png'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.black),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
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
          if (isSender) 
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          if (!isSender) const SizedBox(width: 8.0),
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
          if (!isSender) 
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
