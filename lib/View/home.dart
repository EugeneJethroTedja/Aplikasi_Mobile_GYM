import 'package:flutter/material.dart';
import 'package:sembilan_nih/Profile/profile.dart';
import 'package:sembilan_nih/View/view_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()), 
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Image(image: NetworkImage('https://picsum.photos/200/300'))),
    ListNamaView(),
    Center(child: Text('Profile Page Placeholder')), //
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
