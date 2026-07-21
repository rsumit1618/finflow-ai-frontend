import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? college;
  final String? qualification;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.age,
    this.college,
    this.qualification,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, firstName, lastName, age, college, qualification, createdAt];
}
