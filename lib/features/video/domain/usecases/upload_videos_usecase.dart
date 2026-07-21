import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/usecases/usecase.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';

class UploadVideosUseCase implements UseCase<List<VideoEntity>, List<File>> {
  final VideoRepository repository;

  UploadVideosUseCase(this.repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(List<File> params) async {
    return await repository.uploadVideos(params);
  }
}
