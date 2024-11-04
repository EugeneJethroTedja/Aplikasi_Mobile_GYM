import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ego Gym',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/list': (context) => const ListPage(),
      },
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1; // Start with Home selected

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ListPage(),
    HomeContent(),
    Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 158, 95, 0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.black),
            label: 'List',
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
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/image.jpeg',
                          width: 800,
                          height: 200,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/alat.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tentang Kita',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Ego Gym adalah aplikasi yang berguna untuk mempermudah para member gym agar mereka dapat memenuhi kebutuhan jasmani dengan lebih praktis dan tentunya anti ribet.',
                                    style: TextStyle(color: Colors.grey[400]),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the List page
                                Navigator.of(context).pushNamed('/list');
                              },
                              child: const Icon(
                                Icons
                                    .arrow_forward, // Change the icon if needed
                                color: Colors.orange,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GymCard(
                      imageUrl: 'assets/images/trainer.jpg',
                      title: 'TRAINER',
                      align: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    GymCard(
                      imageUrl: 'assets/images/alat.jpg',
                      title: 'ALAT',
                      align: TextAlign.right,
                    ),
                    const SizedBox(height: 20),
                    GymCard(
                      imageUrl: 'assets/images/kelas.jpeg',
                      title: 'KELAS',
                      align: TextAlign.left,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GymCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final TextAlign align;

  const GymCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.align = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: align,
            ),
          ),
        ],
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Page'),
      ),
      body: Center(
        child: Text(
          'This is the List Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
