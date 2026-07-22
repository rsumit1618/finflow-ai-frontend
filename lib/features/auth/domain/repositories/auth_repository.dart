import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:finflow_app/features/auth/domain/entities/auth_tokens_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokensEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthTokensEntity>> register({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> getProfile();

  Future<Either<Failure, UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required int age,
    required String college,
    required int qualificationYear,
    required String address,
    required String highestQualification,
    String? profileImage,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isLoggedIn();
}
