import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

@Freezed(genericArgumentFactories: true)
class BaseResponse<T> with _$BaseResponse<T> {
  const factory BaseResponse({
    required bool success,
    required String message,
    T? data,
    List<BaseError>? errors,
  }) = _BaseResponse<T>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);
}

@freezed
class BaseError with _$BaseError {
  const factory BaseError({
    required List<String> path,
    required String message,
  }) = _BaseError;

  factory BaseError.fromJson(Map<String, dynamic> json) =>
      _$BaseErrorFromJson(json);
}
