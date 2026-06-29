import 'dart:convert';

class UserModel {
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;

  String get fullName => '$firstName $lastName'.trim();

  Map<String, Object?> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'password': password,
  };

  factory UserModel.fromJson(Map<String, Object?> json) {
    return UserModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  String encode() => jsonEncode(toJson());

  factory UserModel.decode(String source) {
    return UserModel.fromJson(jsonDecode(source) as Map<String, Object?>);
  }
}
