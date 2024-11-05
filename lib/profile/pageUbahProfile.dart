import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _imagePath;

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              _buildOptionButton(
                context: context,
                title: 'Ambil Foto',
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraView(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _imagePath = result;
                    });
                  }
                },
              ),
              _buildOptionButton(
                context: context,
                title: 'Pilih Dari Gallery',
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
                  });
                },
              ),
              Divider(height: 1),
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
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFFCE815E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
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
                          : Icon(
                              Icons.person_outline,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: IconButton(
                        icon: Icon(
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
              SizedBox(height: 20),
              // Form Fields
              _buildInputField(
                icon: Icons.person_outline,
                label: 'Username : Nama Pengguna',
              ),
              _buildInputField(
                icon: Icons.email_outlined,
                label: 'Email : Email Pengguna',
              ),
              _buildInputField(
                icon: Icons.phone_outlined,
                label: 'No Telp : 082134538271',
              ),
              _buildInputField(
                icon: Icons.location_on_outlined,
                label: 'Alamat : Alamat Pengguna',
              ),
              _buildInputField(
                icon: Icons.person,
                label: 'Jenis Kelamin : Laki - laki',
              ),
              _buildInputField(
                icon: Icons.height,
                label: 'Tinggi badan : 198 cm',
              ),
              _buildInputField(
                icon: Icons.monitor_weight_outlined,
                label: 'Berat badan : 87 kg',
              ),
              _buildInputField(
                icon: Icons.cake_outlined,
                label: 'Usia : 70 tahun',
              ),
              SizedBox(height: 20),
              // Save Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save functionality
                  },
                  child: Text(
                    'SIMPAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCE815E),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late Future<void> _initializeCameraFuture;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      _initializeCameraFuture = _cameraController.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeCameraFuture;
            final image = await _cameraController.takePicture();
            if (!mounted) return;

            Navigator.pop(context, image.path);
          } catch (e) {
            debugPrint('Error: $e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
