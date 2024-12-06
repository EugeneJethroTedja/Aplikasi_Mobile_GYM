import 'dart:convert';

class Pelanggan {
  int id;
  String nama;
  String email;
  String noTelp;
  String username;
  String gender;

  Pelanggan({
    required this.id,
    required this.nama,
    required this.email,
    required this.noTelp,
    required this.username,
    required this.gender,
  });

  // Untuk membuat objek Pelanggan dari data JSON (string) yang diterima dari API
  factory Pelanggan.fromRawJson(String str) => Pelanggan.fromJson(json.decode(str));

  factory Pelanggan.fromJson(Map<String, dynamic> json) => Pelanggan(
        id: json["id"],
        nama: json["nama_pelanggan"],
        email: json["email_pelanggan"],
        noTelp: json["noTelp_pelanggan"],
        username: json["username"],
        gender: json["gender"],
      );

  // Untuk membuat data JSON (string) dari objek Pelanggan yang akan dikirim ke API
  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pelanggan": nama,
        "email_pelanggan": email,
        "noTelp_pelanggan": noTelp,
        "username": username,
        "gender": gender,
      };
}
