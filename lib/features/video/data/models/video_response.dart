import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_response.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class VideoResponse with _$VideoResponse {
  const factory VideoResponse({
    required bool success,
    required String message,
    required VideoData data,
  }) = _VideoResponse;

  factory VideoResponse.fromJson(Map<String, dynamic> json) => VideoResponse(
    success: json['success'] as bool,
    message: json['message'] as String,
    data: VideoData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

@Freezed(fromJson: false, toJson: false)
class VideoData with _$VideoData {
  const factory VideoData({
    required List<Video> videos,
    required Pagination? pagination,
    int? totalUploaded,
  }) = _VideoData;

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
    videos: (json['videos'] as List).map((v) => Video.fromJson(v as Map<String, dynamic>)).toList(),
    pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>) : null,
    totalUploaded: json['totalUploaded'] as int?,
  );
}

@Freezed(fromJson: false, toJson: false)
class Video with _$Video {
  const factory Video({
    required String id, 
    required String fileName,
    required int fileSize,
    String? mimeType,
    required String format,
    required String url,
    String? thumbnailUrl,
    required DateTime createdAt,
  }) = _Video;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: (json['id'] ?? '').toString(),
    fileName: json['fileName'] as String? ?? '',
    fileSize: json['fileSize'] as int? ?? 0,
    mimeType: json['mimeType'] as String?,
    format: json['format'] as String? ?? '',
    url: json['url'] as String? ?? '',
    thumbnailUrl: json['thumbnailUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

@Freezed(fromJson: false, toJson: false)
class Pagination with _$Pagination {
  const factory Pagination({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json['total'] as int,
    page: json['page'] as int,
    limit: json['limit'] as int,
    totalPages: json['totalPages'] as int,
  );
}
