// import 'package:flutter/material.dart';
// import 'package:sembilan_nih/Profile/profile.dart';

// // Fungsi untuk menavigasi ke halaman Profile
// void pushProfile(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ProfilePage(), // Hapus const
//     ),
//   );
// }

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     if (index == 2) {
//       // Panggil fungsi pushProfile saat index 2 (Profile) ditekan
//       pushProfile(context);
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   static const List<Widget> _widgetOptions = <Widget>[
//     Center(
//       child: Text('index 0: List'),
//     ),
//     Center(
//       child: Text('index 1: Home'),
//     ),
//     // Hapus widget Profile dari sini, karena kita sudah menavigasi ke halaman profil
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 74, 70, 83),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//       body: _widgetOptions.elementAt(_selectedIndex),
//     );
//   }
// }

// void main() {
//   runApp(const MaterialApp(
//     home: HomeView(),
//   ));
// }
