import 'package:equatable/equatable.dart';

enum UserRole { user, helper, police }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? profileImage;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, email, phone, role, profileImage];
}
