import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final int? userId; // Parameter opsional untuk ID pengguna

  const EditProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _validateAndFetchUserData();
  }

  Future<void> _validateAndFetchUserData() async {
    try {
      debugPrint('Memulai pengambilan data pengguna.');

      final prefs = await SharedPreferences.getInstance();
      final loggedInUserId = prefs.getInt('userId');
      debugPrint('ID pengguna ditemukan di SharedPreferences: $loggedInUserId');

      if (loggedInUserId == null) {
        throw Exception('ID pengguna tidak ditemukan.');
      }

      final userId = widget.userId ?? loggedInUserId;
      debugPrint('Menggunakan ID pengguna untuk fetch data: $userId');

      final apiUrl = 'http://10.0.2.2:8000/api/pelanggan/$userId';
      debugPrint('API URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));
      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        debugPrint('Data pengguna berhasil diambil: $data');

        setState(() {
          usernameController.text = data['username'] ?? '';
          emailController.text = data['email_pelanggan'] ?? '';
          phoneController.text = data['noTelp_pelanggan']?.toString() ?? '';
          addressController.text = data['alamat'] ?? '';
          genderController.text = data['gender'] ?? '';
          heightController.text = data['tinggi_badan']?.toString() ?? '';
          weightController.text = data['berat_badan']?.toString() ?? '';
          ageController.text = data['umur_pelanggan']?.toString() ?? '';
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data pengguna.');
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = widget.userId ?? prefs.getInt('userId');
      debugPrint('ID pengguna untuk update: $userId');

      if (userId == null || userId <= 0) {
        throw Exception('ID pengguna tidak valid.');
      }

      final url = Uri.parse('http://10.0.2.2:8000/api/pelanggan/update/$userId');
      debugPrint('URL untuk update: $url');

      final body = {
        'username': usernameController.text,
        'email_pelanggan': emailController.text,
        'noTelp_pelanggan': phoneController.text,
        'alamat': addressController.text,
        'gender': genderController.text,
        'tinggi_badan': int.tryParse(heightController.text) ?? 0,
        'berat_badan': int.tryParse(weightController.text) ?? 0,
        'umur_pelanggan': int.tryParse(ageController.text) ?? 0,
      };
      debugPrint('Body yang dikirim: ${json.encode(body)}');

      final response = await http.put(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update profile.');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCE815E),
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField(
                controller: usernameController,
                icon: Icons.person_outline,
                label: 'Username',
              ),
              _buildInputField(
                controller: emailController,
                icon: Icons.email_outlined,
                label: 'Email',
              ),
              _buildInputField(
                controller: phoneController,
                icon: Icons.phone_outlined,
                label: 'No Telp',
              ),
              _buildInputField(
                controller: addressController,
                icon: Icons.location_on_outlined,
                label: 'Alamat',
              ),
              _buildInputField(
                controller: genderController,
                icon: Icons.person,
                label: 'Jenis Kelamin',
              ),
              _buildInputField(
                controller: heightController,
                icon: Icons.height,
                label: 'Tinggi Badan',
                isNumber: true,
              ),
              _buildInputField(
                controller: weightController,
                icon: Icons.monitor_weight_outlined,
                label: 'Berat Badan',
                isNumber: true,
              ),
              _buildInputField(
                controller: ageController,
                icon: Icons.cake_outlined,
                label: 'Usia',
                isNumber: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: const Text('SIMPAN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCE815E),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool isNumber = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}
