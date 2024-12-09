  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:sembilan_nih/profile/pageUbahProfile.dart';
  import 'package:sembilan_nih/profile/keamananAkun.dart';
  import 'package:sembilan_nih/profile/kebijakanPrivasi.dart';
  import 'package:sembilan_nih/profile/informasiPengguna.dart';

  class ProfileScreen extends StatefulWidget {
    const ProfileScreen({Key? key}) : super(key: key);

    @override
    State<ProfileScreen> createState() => _ProfileScreenState();
  }

  class _ProfileScreenState extends State<ProfileScreen> {
    Map<String, dynamic>? userData;
    bool isLoading = true;

    @override
    void initState() {
      super.initState();
      validateAndFetchUserData();
    }

 Future<void> validateAndFetchUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserId = prefs.getInt('userId');

    if (loggedInUserId == null) {
      throw Exception('ID pengguna tidak ditemukan di session.');
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/pelanggan/$loggedInUserId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // Tambahkan "storage/" ke profile_picture jika perlu
      final profilePicture = data['profile_picture'];
      data['profile_picture'] =
          profilePicture != null && !profilePicture.startsWith('storage/')
              ? 'storage/$profilePicture'
              : profilePicture;

      debugPrint('Profile picture URL: ${data['profile_picture']}');

      setState(() {
        userData = data;
        isLoading = false;
      });
    } else {
      throw Exception('Gagal mengambil data pengguna');
    }
  } catch (e) {
    debugPrint('Error di validateAndFetchUserData: $e');
    setState(() {
      userData = {'error': e.toString()};
      isLoading = false;
    });
  }
}

    @override
    Widget build(BuildContext context) {
      if (isLoading) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFCD853F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(top: 50, bottom: 25),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 28,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
  clipBehavior: Clip.none,
  children: [
CircleAvatar(
  radius: 45,
  backgroundColor: Colors.grey[300],
  child: userData?['profile_picture'] != null
      ? ClipOval(
          child: Image.network(
            'http://10.0.2.2:8000/uploads/profile_pictures/${userData?['profile_picture']?.split('/').last}',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return const Icon(
                Icons.person,
                size: 45,
                color: Colors.white,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            },
          ),
        )
      : const Icon(
          Icons.person,
          size: 45,
          color: Colors.white,
        ),
),

    Positioned(
      right: 3,
      bottom: 0,
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProfileScreen(),
            ),
          );
          // Refresh data setelah kembali dari EditProfileScreen
          validateAndFetchUserData();
        },
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: const Color(0xFFCD853F),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 1.2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      ),
    ),
  ],
),
                  const SizedBox(height: 12),
                  Text(
                    userData?['username'] ?? 'Username',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData?['email_pelanggan'] ?? 'Email Pengguna',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Informasi Pengguna',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getInt('userId');

                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InformasiPenggunaScreen(userId: userId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal membuka informasi pengguna. ID tidak ditemukan.'),
                          ),
                        );
                      }
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Keamanan Akun',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreenAkun(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Kebijakan Privasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Log Out',
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMenuItem({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.grey),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
      );
    }

    void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Apakah Anda Yakin Ingin Keluar?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Hanya tutup dialog, tetap di ProfileScreen
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('userId'); // Hapus userId dari SharedPreferences
              
              // Tutup dialog
              Navigator.of(context).pop();
              
              // Navigate ke halaman Login dan hapus semua route sebelumnya
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', // Pastikan route name sesuai dengan yang didefinisikan
                (Route<dynamic> route) => false, // Hapus semua route sebelumnya
              );
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
  }