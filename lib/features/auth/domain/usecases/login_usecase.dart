import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/auth/domain/entities/auth_tokens_entity.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthTokensEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthTokensEntity>> call(LoginParams params) async {
    return await repository.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
