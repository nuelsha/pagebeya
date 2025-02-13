import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNum': phone,
      'image': image,
    };
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNum'] ?? '',
      image: json['image'],
    );
  }
}
