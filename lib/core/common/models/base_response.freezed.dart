// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseResponse<T> _$BaseResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _BaseResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$BaseResponse<T> {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  T? get data => throw _privateConstructorUsedError;
  List<BaseError>? get errors => throw _privateConstructorUsedError;

  /// Serializes this BaseResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of BaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseResponseCopyWith<T, BaseResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseResponseCopyWith<T, $Res> {
  factory $BaseResponseCopyWith(
          BaseResponse<T> value, $Res Function(BaseResponse<T>) then) =
      _$BaseResponseCopyWithImpl<T, $Res, BaseResponse<T>>;
  @useResult
  $Res call({bool success, String message, T? data, List<BaseError>? errors});
}

/// @nodoc
class _$BaseResponseCopyWithImpl<T, $Res, $Val extends BaseResponse<T>>
    implements $BaseResponseCopyWith<T, $Res> {
  _$BaseResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = freezed,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<BaseError>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseResponseImplCopyWith<T, $Res>
    implements $BaseResponseCopyWith<T, $Res> {
  factory _$$BaseResponseImplCopyWith(_$BaseResponseImpl<T> value,
          $Res Function(_$BaseResponseImpl<T>) then) =
      __$$BaseResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({bool success, String message, T? data, List<BaseError>? errors});
}

/// @nodoc
class __$$BaseResponseImplCopyWithImpl<T, $Res>
    extends _$BaseResponseCopyWithImpl<T, $Res, _$BaseResponseImpl<T>>
    implements _$$BaseResponseImplCopyWith<T, $Res> {
  __$$BaseResponseImplCopyWithImpl(
      _$BaseResponseImpl<T> _value, $Res Function(_$BaseResponseImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of BaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = freezed,
    Object? errors = freezed,
  }) {
    return _then(_$BaseResponseImpl<T>(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<BaseError>?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$BaseResponseImpl<T> implements _BaseResponse<T> {
  const _$BaseResponseImpl(
      {required this.success,
      required this.message,
      this.data,
      final List<BaseError>? errors})
      : _errors = errors;

  factory _$BaseResponseImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$BaseResponseImplFromJson(json, fromJsonT);

  @override
  final bool success;
  @override
  final String message;
  @override
  final T? data;
  final List<BaseError>? _errors;
  @override
  List<BaseError>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BaseResponse<$T>(success: $success, message: $message, data: $data, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseResponseImpl<T> &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(_errors));

  /// Create a copy of BaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseResponseImplCopyWith<T, _$BaseResponseImpl<T>> get copyWith =>
      __$$BaseResponseImplCopyWithImpl<T, _$BaseResponseImpl<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$BaseResponseImplToJson<T>(this, toJsonT);
  }
}

abstract class _BaseResponse<T> implements BaseResponse<T> {
  const factory _BaseResponse(
      {required final bool success,
      required final String message,
      final T? data,
      final List<BaseError>? errors}) = _$BaseResponseImpl<T>;

  factory _BaseResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$BaseResponseImpl<T>.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  T? get data;
  @override
  List<BaseError>? get errors;

  /// Create a copy of BaseResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseResponseImplCopyWith<T, _$BaseResponseImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

BaseError _$BaseErrorFromJson(Map<String, dynamic> json) {
  return _BaseError.fromJson(json);
}

/// @nodoc
mixin _$BaseError {
  List<String> get path => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this BaseError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseErrorCopyWith<BaseError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseErrorCopyWith<$Res> {
  factory $BaseErrorCopyWith(BaseError value, $Res Function(BaseError) then) =
      _$BaseErrorCopyWithImpl<$Res, BaseError>;
  @useResult
  $Res call({List<String> path, String message});
}

/// @nodoc
class _$BaseErrorCopyWithImpl<$Res, $Val extends BaseError>
    implements $BaseErrorCopyWith<$Res> {
  _$BaseErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseErrorImplCopyWith<$Res>
    implements $BaseErrorCopyWith<$Res> {
  factory _$$BaseErrorImplCopyWith(
          _$BaseErrorImpl value, $Res Function(_$BaseErrorImpl) then) =
      __$$BaseErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> path, String message});
}

/// @nodoc
class __$$BaseErrorImplCopyWithImpl<$Res>
    extends _$BaseErrorCopyWithImpl<$Res, _$BaseErrorImpl>
    implements _$$BaseErrorImplCopyWith<$Res> {
  __$$BaseErrorImplCopyWithImpl(
      _$BaseErrorImpl _value, $Res Function(_$BaseErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? message = null,
  }) {
    return _then(_$BaseErrorImpl(
      path: null == path
          ? _value._path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseErrorImpl implements _BaseError {
  const _$BaseErrorImpl(
      {required final List<String> path, required this.message})
      : _path = path;

  factory _$BaseErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseErrorImplFromJson(json);

  final List<String> _path;
  @override
  List<String> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  final String message;

  @override
  String toString() {
    return 'BaseError(path: $path, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseErrorImpl &&
            const DeepCollectionEquality().equals(other._path, _path) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_path), message);

  /// Create a copy of BaseError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseErrorImplCopyWith<_$BaseErrorImpl> get copyWith =>
      __$$BaseErrorImplCopyWithImpl<_$BaseErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseErrorImplToJson(
      this,
    );
  }
}

abstract class _BaseError implements BaseError {
  const factory _BaseError(
      {required final List<String> path,
      required final String message}) = _$BaseErrorImpl;

  factory _BaseError.fromJson(Map<String, dynamic> json) =
      _$BaseErrorImpl.fromJson;

  @override
  List<String> get path;
  @override
  String get message;

  /// Create a copy of BaseError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseErrorImplCopyWith<_$BaseErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
