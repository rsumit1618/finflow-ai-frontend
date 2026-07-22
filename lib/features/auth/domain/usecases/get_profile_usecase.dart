import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getProfile();
  }
}
