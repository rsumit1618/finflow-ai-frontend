import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';

class DeleteVideoUseCase implements UseCase<void, String> {
  final VideoRepository repository;

  DeleteVideoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteVideo(params);
  }
}
