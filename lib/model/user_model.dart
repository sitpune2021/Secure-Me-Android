import 'package:equatable/equatable.dart';

enum UserRole { Police, Manager, Gym_Person }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String roleString;
  final String? profileImage;
  
  // Verification & Trust (Safety System)
  final bool isVerified;
  final int trustScore; // 0-100 based on previous help given
  final int peopleHelped;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.roleString,
    this.profileImage,
    this.isVerified = false,
    this.trustScore = 50,
    this.peopleHelped = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        profileImage,
        isVerified,
        trustScore,
        peopleHelped
      ];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? roleString,
    String? profileImage,
    bool? isVerified,
    int? trustScore,
    int? peopleHelped,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      roleString: roleString ?? this.roleString,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      trustScore: trustScore ?? this.trustScore,
      peopleHelped: peopleHelped ?? this.peopleHelped,
    );
  }
}
