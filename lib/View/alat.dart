import 'package:flutter/material.dart';

class AlatScreen extends StatelessWidget {
  const AlatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Alat', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
