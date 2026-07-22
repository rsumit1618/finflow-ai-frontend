// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AuthData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_$AuthDataImpl _$$AuthDataImplFromJson(Map<String, dynamic> json) =>
    _$AuthDataImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthDataImplToJson(_$AuthDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'tokens': instance.tokens,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      userId: json['userId'] as String,
      email: json['email'] as String,
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'profile': instance.profile,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      age: (json['age'] as num?)?.toInt(),
      college: json['college'] as String?,
      qualificationYear: (json['qualificationYear'] as num?)?.toInt(),
      address: json['address'] as String?,
      highestQualification: json['highestQualification'] as String?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'college': instance.college,
      'qualificationYear': instance.qualificationYear,
      'address': instance.address,
      'highestQualification': instance.highestQualification,
      'profileImage': instance.profileImage,
    };

_$TokensImpl _$$TokensImplFromJson(Map<String, dynamic> json) => _$TokensImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$TokensImplToJson(_$TokensImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
