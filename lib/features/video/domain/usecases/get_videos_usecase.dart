import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/usecases/usecase.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';

class GetVideosUseCase implements UseCase<List<VideoEntity>, GetVideosParams> {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(
      GetVideosParams params) async {
    return await repository.getVideos(page: params.page, limit: params.limit);
  }
}

class GetVideosParams {
  final int page;
  final int limit;

  GetVideosParams({required this.page, required this.limit});
}
