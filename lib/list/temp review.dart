import 'package:flutter/material.dart';

class TrainerPage extends StatefulWidget {
  const TrainerPage({Key? key}) : super(key: key);

  @override
  _TrainerPageState createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.of(context).pushNamed('/home');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 95, 0),
        title: const Text('Trainer Anda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTrainerCard(
              'Ade Rai',
              'Angkat Beban',
              '28-08-2024',
              '700.000',
              'Review',
              'assets/images/trainer1.png',
            ),
            _buildTrainerCard(
              'Aaron Panji',
              'Aerobic',
              '26-08-2024',
              '900.000',
              'Selesai',
              'assets/images/trainer3.jpg',
              isCompleted: true,
              review: 5,
            ),
            _buildTrainerCard(
              'Krisnadewa',
              'Atletik',
              '23-08-2024',
              '140.000',
              'Selesai',
              'assets/images/trainer5.jpg',
              isCompleted: true,
              review: 4,
            ),
            _buildTrainerCard(
              'Ade Kakak',
              'Perbesar Masa Otot',
              '17-08-2024',
              '20.000',
              'Selesai',
              'assets/images/trainer4.jpg',
              isCompleted: true,
              review: 3,
            ),
          ],
        ),
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
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
    );
  }

  Widget _buildTrainerCard(
    String name,
    String specialty,
    String date,
    String price,
    String buttonText,
    String imagePath, {
    bool isCompleted = false,
    int? review,
  }) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text.rich(
                      TextSpan(
                        text: 'Spesialisasi : ',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                        children: [
                          TextSpan(text: specialty, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Tanggal      : ',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                        children: [
                          TextSpan(text: date, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Harga            : ',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                        children: [
                          TextSpan(text: 'Rp. $price', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (isCompleted && review != null)
                      Text(
                        'Review          : $review/5',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.black),
                    if (isCompleted)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    else
                      Text('Berlaku Hingga $date', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    if (!isCompleted)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(trainerName: name),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text(buttonText, style: const TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewPage extends StatelessWidget {
  final String trainerName;

  const ReviewPage({Key? key, required this.trainerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review $trainerName'),
      ),
      body: Center(
        child: Text('Halaman Review untuk $trainerName'),
      ),
    );
  }
}
