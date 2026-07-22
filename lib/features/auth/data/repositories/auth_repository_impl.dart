import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:finflow_app/core/common/business/errors/exceptions.dart';
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

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError || 
        e.type == DioExceptionType.connectionTimeout ||
        e.error is SocketException) {
      return const NetworkFailure('Unable to connect to server. Please check your internet or server status.');
    }
    
    final message = e.response?.data?['message'] ?? e.message ?? 'Unknown Server Error';
    return ServerFailure(message);
  }

  @override
  Future<Either<Failure, AuthTokensEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(email: email, password: password);
      
      if (response.success && response.data != null) {
        final data = response.data!;
        await localDataSource.cacheTokens(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        );
        return Right(AuthTokensEntity(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        ));
      } else {
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
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
      final response = await remoteDataSource.register(email: email, password: password);
      
      if (response.success && response.data != null) {
        final data = response.data!;
        await localDataSource.cacheTokens(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        );
        return Right(AuthTokensEntity(
          accessToken: data.tokens.accessToken,
          refreshToken: data.tokens.refreshToken,
        ));
      } else {
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userModel = await remoteDataSource.getProfile();
      return Right(UserEntity(
        id: userModel.id,
        email: userModel.email,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        age: userModel.age,
        college: userModel.college,
        qualificationYear: userModel.qualificationYear,
        address: userModel.address,
        highestQualification: userModel.highestQualification,
        profileImage: userModel.profileImage,
        createdAt: DateTime.parse(userModel.createdAt),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required int age,
    required String college,
    required int qualificationYear,
    required String address,
    required String highestQualification,
    String? profileImage,
  }) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        age: age,
        college: college,
        qualificationYear: qualificationYear,
        address: address,
        highestQualification: highestQualification,
        profileImage: profileImage,
      );
      return Right(UserEntity(
        id: userModel.id,
        email: userModel.email,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        age: userModel.age,
        college: userModel.college,
        qualificationYear: userModel.qualificationYear,
        address: userModel.address,
        highestQualification: userModel.highestQualification,
        profileImage: userModel.profileImage,
        createdAt: DateTime.parse(userModel.createdAt),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
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
