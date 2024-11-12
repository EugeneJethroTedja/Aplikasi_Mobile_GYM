import 'package:flutter/material.dart';
import 'package:sembilan_nih/profile/pageUbahProfile.dart';

class ProfileScreenAkun extends StatelessWidget {
  const ProfileScreenAkun ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        iconSize: 28, // Perbesar ukuran ikon
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
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, size: 45, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nama Pengguna',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Email Pengguna',
                  style: TextStyle(
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
                    // Handle action for changing password
                  },
                ),
                _buildMenuItem(
                  icon: Icons.phone,
                  title: 'Ganti No Telp',
                  onTap: () {
                    // Handle action for changing phone number
                  },
                ),
                _buildMenuItem(
                  icon: Icons.email,
                  title: 'Ganti Email',
                  onTap: () {
                    // Handle action for changing email
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
