import 'dart:convert';
import 'package:http/http.dart' as http;  

class PelangganService {
 static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, String>> getUserByUsername(String username) async {
    try {
      final url = Uri.parse('$_baseUrl/api/pelanggan/username/$username');
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');  // Tambahkan logging
      print('Response body: ${response.body}');  // Tambahkan logging

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch user');
      }

      final data = json.decode(response.body)['data'];

      return {
        'nama': data['nama_pelanggan'],
        'email': data['email_pelanggan'],
        'notelp': data['noTelp_pelanggan'],
        'gender': data['gender'],
        'umur': data['umur_pelanggan'].toString(),
        'username': data['username'],
      };
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

   static Future<void> updatePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.http(_baseUrl, '/api/pelanggan/update-password/$username');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['message']);
      }
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }

   static Future<void> updatePhone({
    required String username,
    required String oldPhone,
    required String newPhone,
  }) async {
    try {
      final url = Uri.http(_baseUrl, '/api/pelanggan/update-phone/$username');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'old_phone': oldPhone,
          'new_phone': newPhone,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['message']);
      }
    } catch (e) {
      throw Exception('Error updating phone number: $e');
    }
  }

   static Future<void> updateEmail({
    required String username,
    required String oldEmail,
    required String newEmail,
  }) async {
    try {
      final url = Uri.http(_baseUrl, '/api/pelanggan/update-email/$username');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'old_email': oldEmail,
          'new_email': newEmail,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['message']);
      }
    } catch (e) {
      throw Exception('Error updating email: $e');
    }
  }
  static Future<Map<String, String>> getUserByToken(String token) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/user');

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil data pengguna');
  }

  final data = json.decode(response.body)['data'];
  return {
    'nama': data['nama'],
    'email': data['email'],
    'notelp': data['noTelp'],
  };
}

}
