import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/auth/domain/entities/auth_tokens_entity.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AuthTokensEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthTokensEntity>> call(RegisterParams params) async {
    return await repository.register(email: params.email, password: params.password);
  }
}

class RegisterParams {
  final String email;
  final String password;

  RegisterParams({required this.email, required this.password});
}
