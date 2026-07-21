import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<VideoEntity>>> getVideos(
      {int page = 1, int limit = 10});
  Future<Either<Failure, VideoEntity>> getVideo(String id);
  Future<Either<Failure, List<VideoEntity>>> uploadVideos(List<File> videos);
  Future<Either<Failure, void>> deleteVideo(String id);
  Future<Either<Failure, String>> uploadThumbnail(String id, File thumbnail);
}
