import 'package:sks/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({required super.email, required super.name, required super.id});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      id: map['id'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return UserModel(email: email ?? "", name: name ?? "", id: id ?? "");
  }
}
