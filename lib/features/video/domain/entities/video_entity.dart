import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String fileName;
  final int fileSize;
  final String? mimeType;
  final String format;
  final String url;
  final String? thumbnailUrl;
  final DateTime createdAt;

  const VideoEntity({
    required this.id,
    required this.fileName,
    required this.fileSize,
    this.mimeType,
    required this.format,
    required this.url,
    this.thumbnailUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, fileName, fileSize, mimeType, format, url, thumbnailUrl, createdAt];
}
