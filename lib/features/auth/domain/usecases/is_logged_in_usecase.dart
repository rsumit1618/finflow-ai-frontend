import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isLoggedIn();
  }
}
