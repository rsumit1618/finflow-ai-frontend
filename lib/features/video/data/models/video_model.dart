import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String id,
    required String fileName,
    required int fileSize,
    required String format,
    required String url,
    String? thumbnailUrl,
    required String createdAt,
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  const VideoModel._();

  VideoEntity toEntity() => VideoEntity(
        id: id,
        fileName: fileName,
        fileSize: fileSize,
        format: format,
        url: url,
        thumbnailUrl: thumbnailUrl,
        createdAt: DateTime.parse(createdAt),
      );
}
