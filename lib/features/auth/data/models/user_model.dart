import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finflow_app/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    int? age,
    String? college,
    int? qualificationYear,
    String? address,
    String? highestQualification,
    String? profileImage,
    required String createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = (json['user'] as Map<String, dynamic>?) ?? json;
    final profile = (userData['profile'] as Map<String, dynamic>?) ?? {};

    return UserModel(
      id: (userData['userId'] ?? userData['id'] ?? userData['_id'] ?? '').toString(),
      email: (userData['email'] ?? '').toString(),
      firstName: (profile['firstName'] ?? userData['firstName'])?.toString(),
      lastName: (profile['lastName'] ?? userData['lastName'])?.toString(),
      age: (profile['age'] ?? userData['age']) is int 
          ? (profile['age'] ?? userData['age']) 
          : int.tryParse((profile['age'] ?? userData['age'])?.toString() ?? ''),
      college: (profile['college'] ?? userData['college'])?.toString(),
      qualificationYear: (profile['qualificationYear'] ?? userData['qualificationYear']) is int 
          ? (profile['qualificationYear'] ?? userData['qualificationYear']) 
          : int.tryParse((profile['qualificationYear'] ?? userData['qualificationYear'])?.toString() ?? ''),
      address: (profile['address'] ?? userData['address'])?.toString(),
      highestQualification: (profile['highestQualification'] ?? userData['highestQualification'])?.toString(),
      profileImage: (profile['profileImage'] ?? userData['profileImage'])?.toString(),
      createdAt: (userData['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
    );
  }

  const UserModel._();

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        age: age,
        college: college,
        qualificationYear: qualificationYear,
        address: address,
        highestQualification: highestQualification,
        profileImage: profileImage,
        createdAt: DateTime.parse(createdAt),
      );
}
