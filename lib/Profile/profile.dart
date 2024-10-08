import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String notelp = '';
  String alamat = '';
  String jenisKelamin = '';
  String tinggiBadan = '';
  String beratBadan = '';
  String usia = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      notelp = prefs.getString('notelp') ?? '';
      alamat = prefs.getString('alamat') ?? '';
      jenisKelamin = prefs.getString('jenisKelamin') ?? '';
      tinggiBadan = prefs.getString('tinggiBadan') ?? '';
      beratBadan = prefs.getString('beratBadan') ?? '';
      usia = prefs.getString('usia') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.lightBlueAccent,


      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Profil
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(''), // User avatar
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    username.isNotEmpty ? username : 'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email.isNotEmpty ? email : '@username',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Menampilkan data registrasi
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ProfileMenuItem(
                    icon: Icons.person,
                    text: 'Username: $username',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.email,
                    text: 'Email: $email',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.phone,
                    text: 'No. Telepon: $notelp',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.home,
                    text: 'Alamat: $alamat',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.person,
                    text: 'Jenis Kelamin: $jenisKelamin',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.height,
                    text: 'Tinggi Badan: $tinggiBadan',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.fitness_center,
                    text: 'Berat Badan: $beratBadan',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.cake,
                    text: 'Usia: $usia',
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Sign Out',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF6F87FF),
        ),
        title: Text(text),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
