// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  VideoData get data => throw _privateConstructorUsedError;

  /// Create a copy of VideoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoResponseCopyWith<VideoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoResponseCopyWith<$Res> {
  factory $VideoResponseCopyWith(
          VideoResponse value, $Res Function(VideoResponse) then) =
      _$VideoResponseCopyWithImpl<$Res, VideoResponse>;
  @useResult
  $Res call({bool success, String message, VideoData data});

  $VideoDataCopyWith<$Res> get data;
}

/// @nodoc
class _$VideoResponseCopyWithImpl<$Res, $Val extends VideoResponse>
    implements $VideoResponseCopyWith<$Res> {
  _$VideoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = null,
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
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VideoData,
    ) as $Val);
  }

  /// Create a copy of VideoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoDataCopyWith<$Res> get data {
    return $VideoDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VideoResponseImplCopyWith<$Res>
    implements $VideoResponseCopyWith<$Res> {
  factory _$$VideoResponseImplCopyWith(
          _$VideoResponseImpl value, $Res Function(_$VideoResponseImpl) then) =
      __$$VideoResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, VideoData data});

  @override
  $VideoDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$VideoResponseImplCopyWithImpl<$Res>
    extends _$VideoResponseCopyWithImpl<$Res, _$VideoResponseImpl>
    implements _$$VideoResponseImplCopyWith<$Res> {
  __$$VideoResponseImplCopyWithImpl(
      _$VideoResponseImpl _value, $Res Function(_$VideoResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_$VideoResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VideoData,
    ));
  }
}

/// @nodoc

class _$VideoResponseImpl implements _VideoResponse {
  const _$VideoResponseImpl(
      {required this.success, required this.message, required this.data});

  @override
  final bool success;
  @override
  final String message;
  @override
  final VideoData data;

  @override
  String toString() {
    return 'VideoResponse(success: $success, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, success, message, data);

  /// Create a copy of VideoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoResponseImplCopyWith<_$VideoResponseImpl> get copyWith =>
      __$$VideoResponseImplCopyWithImpl<_$VideoResponseImpl>(this, _$identity);
}

abstract class _VideoResponse implements VideoResponse {
  const factory _VideoResponse(
      {required final bool success,
      required final String message,
      required final VideoData data}) = _$VideoResponseImpl;

  @override
  bool get success;
  @override
  String get message;
  @override
  VideoData get data;

  /// Create a copy of VideoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoResponseImplCopyWith<_$VideoResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VideoData {
  List<Video> get videos => throw _privateConstructorUsedError;
  Pagination? get pagination => throw _privateConstructorUsedError;
  int? get totalUploaded => throw _privateConstructorUsedError;

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoDataCopyWith<VideoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoDataCopyWith<$Res> {
  factory $VideoDataCopyWith(VideoData value, $Res Function(VideoData) then) =
      _$VideoDataCopyWithImpl<$Res, VideoData>;
  @useResult
  $Res call({List<Video> videos, Pagination? pagination, int? totalUploaded});

  $PaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$VideoDataCopyWithImpl<$Res, $Val extends VideoData>
    implements $VideoDataCopyWith<$Res> {
  _$VideoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videos = null,
    Object? pagination = freezed,
    Object? totalUploaded = freezed,
  }) {
    return _then(_value.copyWith(
      videos: null == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<Video>,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination?,
      totalUploaded: freezed == totalUploaded
          ? _value.totalUploaded
          : totalUploaded // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $PaginationCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VideoDataImplCopyWith<$Res>
    implements $VideoDataCopyWith<$Res> {
  factory _$$VideoDataImplCopyWith(
          _$VideoDataImpl value, $Res Function(_$VideoDataImpl) then) =
      __$$VideoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Video> videos, Pagination? pagination, int? totalUploaded});

  @override
  $PaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$VideoDataImplCopyWithImpl<$Res>
    extends _$VideoDataCopyWithImpl<$Res, _$VideoDataImpl>
    implements _$$VideoDataImplCopyWith<$Res> {
  __$$VideoDataImplCopyWithImpl(
      _$VideoDataImpl _value, $Res Function(_$VideoDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videos = null,
    Object? pagination = freezed,
    Object? totalUploaded = freezed,
  }) {
    return _then(_$VideoDataImpl(
      videos: null == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<Video>,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination?,
      totalUploaded: freezed == totalUploaded
          ? _value.totalUploaded
          : totalUploaded // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$VideoDataImpl implements _VideoData {
  const _$VideoDataImpl(
      {required final List<Video> videos,
      required this.pagination,
      this.totalUploaded})
      : _videos = videos;

  final List<Video> _videos;
  @override
  List<Video> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  final Pagination? pagination;
  @override
  final int? totalUploaded;

  @override
  String toString() {
    return 'VideoData(videos: $videos, pagination: $pagination, totalUploaded: $totalUploaded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoDataImpl &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.totalUploaded, totalUploaded) ||
                other.totalUploaded == totalUploaded));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_videos), pagination, totalUploaded);

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoDataImplCopyWith<_$VideoDataImpl> get copyWith =>
      __$$VideoDataImplCopyWithImpl<_$VideoDataImpl>(this, _$identity);
}

abstract class _VideoData implements VideoData {
  const factory _VideoData(
      {required final List<Video> videos,
      required final Pagination? pagination,
      final int? totalUploaded}) = _$VideoDataImpl;

  @override
  List<Video> get videos;
  @override
  Pagination? get pagination;
  @override
  int? get totalUploaded;

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoDataImplCopyWith<_$VideoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Video {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCopyWith<Video> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCopyWith<$Res> {
  factory $VideoCopyWith(Video value, $Res Function(Video) then) =
      _$VideoCopyWithImpl<$Res, Video>;
  @useResult
  $Res call(
      {String id,
      String fileName,
      int fileSize,
      String? mimeType,
      String format,
      String url,
      String? thumbnailUrl,
      DateTime createdAt});
}

/// @nodoc
class _$VideoCopyWithImpl<$Res, $Val extends Video>
    implements $VideoCopyWith<$Res> {
  _$VideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = freezed,
    Object? format = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoImplCopyWith<$Res> implements $VideoCopyWith<$Res> {
  factory _$$VideoImplCopyWith(
          _$VideoImpl value, $Res Function(_$VideoImpl) then) =
      __$$VideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fileName,
      int fileSize,
      String? mimeType,
      String format,
      String url,
      String? thumbnailUrl,
      DateTime createdAt});
}

/// @nodoc
class __$$VideoImplCopyWithImpl<$Res>
    extends _$VideoCopyWithImpl<$Res, _$VideoImpl>
    implements _$$VideoImplCopyWith<$Res> {
  __$$VideoImplCopyWithImpl(
      _$VideoImpl _value, $Res Function(_$VideoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = freezed,
    Object? format = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$VideoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$VideoImpl implements _Video {
  const _$VideoImpl(
      {required this.id,
      required this.fileName,
      required this.fileSize,
      this.mimeType,
      required this.format,
      required this.url,
      this.thumbnailUrl,
      required this.createdAt});

  @override
  final String id;
  @override
  final String fileName;
  @override
  final int fileSize;
  @override
  final String? mimeType;
  @override
  final String format;
  @override
  final String url;
  @override
  final String? thumbnailUrl;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Video(id: $id, fileName: $fileName, fileSize: $fileSize, mimeType: $mimeType, format: $format, url: $url, thumbnailUrl: $thumbnailUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, fileName, fileSize, mimeType,
      format, url, thumbnailUrl, createdAt);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      __$$VideoImplCopyWithImpl<_$VideoImpl>(this, _$identity);
}

abstract class _Video implements Video {
  const factory _Video(
      {required final String id,
      required final String fileName,
      required final int fileSize,
      final String? mimeType,
      required final String format,
      required final String url,
      final String? thumbnailUrl,
      required final DateTime createdAt}) = _$VideoImpl;

  @override
  String get id;
  @override
  String get fileName;
  @override
  int get fileSize;
  @override
  String? get mimeType;
  @override
  String get format;
  @override
  String get url;
  @override
  String? get thumbnailUrl;
  @override
  DateTime get createdAt;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Pagination {
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Create a copy of Pagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationCopyWith<Pagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationCopyWith<$Res> {
  factory $PaginationCopyWith(
          Pagination value, $Res Function(Pagination) then) =
      _$PaginationCopyWithImpl<$Res, Pagination>;
  @useResult
  $Res call({int total, int page, int limit, int totalPages});
}

/// @nodoc
class _$PaginationCopyWithImpl<$Res, $Val extends Pagination>
    implements $PaginationCopyWith<$Res> {
  _$PaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationImplCopyWith<$Res>
    implements $PaginationCopyWith<$Res> {
  factory _$$PaginationImplCopyWith(
          _$PaginationImpl value, $Res Function(_$PaginationImpl) then) =
      __$$PaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int page, int limit, int totalPages});
}

/// @nodoc
class __$$PaginationImplCopyWithImpl<$Res>
    extends _$PaginationCopyWithImpl<$Res, _$PaginationImpl>
    implements _$$PaginationImplCopyWith<$Res> {
  __$$PaginationImplCopyWithImpl(
      _$PaginationImpl _value, $Res Function(_$PaginationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Pagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginationImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PaginationImpl implements _Pagination {
  const _$PaginationImpl(
      {required this.total,
      required this.page,
      required this.limit,
      required this.totalPages});

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'Pagination(total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, total, page, limit, totalPages);

  /// Create a copy of Pagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationImplCopyWith<_$PaginationImpl> get copyWith =>
      __$$PaginationImplCopyWithImpl<_$PaginationImpl>(this, _$identity);
}

abstract class _Pagination implements Pagination {
  const factory _Pagination(
      {required final int total,
      required final int page,
      required final int limit,
      required final int totalPages}) = _$PaginationImpl;

  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of Pagination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationImplCopyWith<_$PaginationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
