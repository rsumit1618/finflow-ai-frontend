import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? college;
  final int? qualificationYear;
  final String? address;
  final String? highestQualification;
  final String? profileImage;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.age,
    this.college,
    this.qualificationYear,
    this.address,
    this.highestQualification,
    this.profileImage,
    required this.createdAt,
  });

  bool get isProfileComplete => 
    firstName != null && 
    lastName != null && 
    highestQualification != null && 
    college != null;

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        age,
        college,
        qualificationYear,
        address,
        highestQualification,
        profileImage,
        createdAt,
      ];
}
