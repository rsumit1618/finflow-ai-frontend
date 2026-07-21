import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/exceptions.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/features/auth/domain/entities/auth_tokens_entity.dart';
import 'package:finflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:finflow_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:finflow_app/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthTokensEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final responseModel = await remoteDataSource.login(email: email, password: password);
      await localDataSource.cacheTokens(
        accessToken: responseModel.accessToken,
        refreshToken: responseModel.refreshToken,
      );
      return Right(responseModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokensEntity>> register({
    required String email,
    required String password,
  }) async {
    try {
      final responseModel = await remoteDataSource.register(email: email, password: password);
      await localDataSource.cacheTokens(
        accessToken: responseModel.accessToken,
        refreshToken: responseModel.refreshToken,
      );
      return Right(responseModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userModel = await remoteDataSource.getProfile();
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    final token = await localDataSource.getAccessToken();
    return Right(token != null);
  }
}
