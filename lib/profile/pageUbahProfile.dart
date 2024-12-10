import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class EditProfileScreen extends StatefulWidget {
  final int? userId;

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

  String? _imagePath;
  String? _imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _validateAndFetchUserData();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
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
         _imageUrl = data['profile_picture']; 
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
      _showErrorDialog('Gagal memuat data profil');
    }
  }

  Future<void> _uploadImage(File imageFile, int userId) async {
  try {
    var uri = Uri.parse('http://10.0.2.2:8000/api/pelanggan/upload-photo/$userId');
    var request = http.MultipartRequest('POST', uri);
    
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    
    var multipartFile = http.MultipartFile(
      'photo',
      stream,
      length,
      filename: path.basename(imageFile.path),
      contentType: MediaType('image', 'jpeg'),
    );
    
    request.files.add(multipartFile);
    debugPrint('Mengirim request upload foto...');

    var response = await request.send();
    var responseStr = await http.Response.fromStream(response);
    
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(responseStr.body);
      setState(() {
        // Update imageUrl dengan path yang baru
        _imageUrl = jsonResponse['profile_picture'];
      });
      _showSuccessMessage('Foto berhasil diupload');
    } else {
      throw Exception('Gagal mengupload foto: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error mengupload foto: $e');
    _showErrorDialog('Gagal mengupload foto');
  }
}
  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              _buildOptionButton(
                context: context,
                title: 'Ambil Foto',
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _imagePath = pickedFile.path;
                    });
                  }
                },
              ),
              _buildOptionButton(
                context: context,
                title: 'Pilih Dari Gallery',
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _imagePath = pickedFile.path;
                    });
                  }
                },
              ),
              _buildOptionButton(
                context: context,
                title: 'Hapus Foto',
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _imagePath = null;
                    _imageUrl = null;
                  });
                },
              ),
              const Divider(height: 1),
              _buildOptionButton(
                context: context,
                title: 'Batal',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final userId = widget.userId ?? prefs.getInt('userId');
      debugPrint('ID pengguna untuk update: $userId');

      if (userId == null || userId <= 0) {
        throw Exception('ID pengguna tidak valid.');
      }

      // Upload foto jika ada foto baru
      if (_imagePath != null) {
        await _uploadImage(File(_imagePath!), userId);
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
        'profile_picture': _imageUrl?.replaceAll('http://10.0.2.2:8000/', ''),
      };
      debugPrint('Body yang dikirim: ${json.encode(body)}');

      final response = await http.put(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSuccessMessage('Profil berhasil diperbarui');
        Navigator.pop(context);
      } else {
        throw Exception('Gagal memperbarui profil: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      _showErrorDialog('Gagal memperbarui profil: $e');
    } finally {
      setState(() => isLoading = false);
    }
}
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
Widget _buildProfileImage() {
  return CircleAvatar(
    radius: 40,
    backgroundColor: Colors.grey[300],
    child: _imagePath != null
        ? ClipOval(
            child: Image.file(
              File(_imagePath!),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          )
        : _imageUrl != null
            ? ClipOval(
                child: Image.network(
                    'http://10.0.2.2:8000/uploads/profile_pictures/${_imageUrl?.split('/').last}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading image: $error');
                      return Icon(Icons.person_outline, size: 40, color: Colors.grey[600]);
                    },
                  ),
              )
            : Icon(Icons.person_outline, size: 40, color: Colors.grey[600]),
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
            return 'Field tidak boleh kosong';
          }
          return null;
        },
      ),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    _buildProfileImage(),
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Color(0xFFCE815E),
                          size: 30,
                        ),
                        onPressed: () => _showPhotoOptions(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _updateProfile(),
                  style: ElevatedButton.styleFrom(
                                     backgroundColor: const Color(0xFFCE815E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
