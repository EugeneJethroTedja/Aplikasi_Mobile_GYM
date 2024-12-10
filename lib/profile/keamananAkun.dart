import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembilan_nih/profile/ubahEmail.dart';
import 'package:sembilan_nih/profile/ubahNoTelepon.dart';
import 'package:sembilan_nih/profile/ubahPassword.dart';

class ProfileScreenAkun extends StatefulWidget {
  const ProfileScreenAkun({Key? key}) : super(key: key);

  @override
  State<ProfileScreenAkun> createState() => _ProfileScreenAkunState();
}

class _ProfileScreenAkunState extends State<ProfileScreenAkun> {
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
                  icon: Icons.lock_outline,
                  title: 'Ganti Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.phone,
                  title: 'Ganti No Telp',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePhoneNumberScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.email,
                  title: 'Ganti Email',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeEmailScreen(),
                      ),
                    );
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
}