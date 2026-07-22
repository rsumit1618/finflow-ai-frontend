import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/core/common/models/file_upload_model.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';

class UploadVideosUseCase
    implements UseCase<List<VideoEntity>, UploadVideosParams> {
  final VideoRepository repository;

  UploadVideosUseCase(this.repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(
      UploadVideosParams params) async {
    return await repository.uploadVideos(params.files,
        onProgress: params.onProgress);
  }
}

class UploadVideosParams {
  final List<FileUploadModel> files;
  final void Function(int, int)? onProgress;

  UploadVideosParams({required this.files, this.onProgress});
}
