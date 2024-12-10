import 'package:flutter/material.dart';
import 'package:sembilan_nih/profile/pagePertama.dart'; 

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key); // Gunakan Key yang benar

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() => <Widget>[
    const Center(
      child: Text('index 0: List'),
    ),
    const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'GYM BABARSARI MANTAP',
            ),
          ),
        ],
      ),
    ),
    const ProfileScreen(), // Pastikan ProfileScreen sudah ada
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> currentWidgetOptions = _widgetOptions(); // Dapatkan widget saat ini

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 74, 70, 83),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFCD853F),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
      body: currentWidgetOptions.elementAt(_selectedIndex), // Tampilkan widget berdasarkan index
    );
  }
}
