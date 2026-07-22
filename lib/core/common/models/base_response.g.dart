// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseResponseImpl<T> _$$BaseResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$BaseResponseImpl<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => BaseError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BaseResponseImplToJson<T>(
  _$BaseResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'errors': instance.errors,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

_$BaseErrorImpl _$$BaseErrorImplFromJson(Map<String, dynamic> json) =>
    _$BaseErrorImpl(
      path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$BaseErrorImplToJson(_$BaseErrorImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'message': instance.message,
    };
