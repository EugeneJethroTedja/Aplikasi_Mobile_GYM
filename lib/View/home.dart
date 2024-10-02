import 'package:flutter/material.dart';
import 'package:sembilan_nih/View/view_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  //*selected index berkaitan dengan index halaman pada bottomNavigasi
  int _selectedIndex = 0;
  //*fungsi yang nantinya akan dijalankan setiap menekan meu pada navbar
  void _onItemTapped(int index) {
    //*setState berkaitan dengan fungsi untuk menampilkan perubahan kondisi dan dalam banyak kasus akan menggunakan ini
    setState(() {
      _selectedIndex = index;
    });
  }

  //*menampung list widget yang akan ditampilkan sesuai index yang dipilih
  static const List<Widget> _widgetOptions = <Widget>[

    //*index 0
    Center(
      child: Image(image: NetworkImage('https://picsum.photos/200/300'))
    ),
    //* index 1




















    
    ListNamaView(), //*jika error di comment dulu aja
    //* index 2
    Center(
      child: Text(
        'Index 3: Profile',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //* setting navigasi bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list,),label: 'List'),
        BottomNavigationBarItem(icon: Icon(Icons.person,),label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}