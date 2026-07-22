import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required bool success,
    required String message,
    AuthData? data,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class AuthData with _$AuthData {
  const factory AuthData({
    required User user,
    required Tokens tokens,
  }) = _AuthData;

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required String userId,
    required String email,
    UserProfile? profile,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? firstName,
    String? lastName,
    int? age,
    String? college,
    int? qualificationYear,
    String? address,
    String? highestQualification,
    String? profileImage,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class Tokens with _$Tokens {
  const factory Tokens({
    required String accessToken,
    required String refreshToken,
  }) = _Tokens;

  factory Tokens.fromJson(Map<String, dynamic> json) =>
      _$TokensFromJson(json);
}
