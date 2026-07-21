import 'package:dio/dio.dart';
import 'package:finflow_app/core/common/constants/api_constants.dart';
import 'package:finflow_app/core/common/errors/exceptions.dart';
import 'package:finflow_app/features/auth/data/models/auth_response_model.dart';
import 'package:finflow_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(
      {required String email, required String password});
  Future<AuthResponseModel> register(
      {required String email, required String password});
  Future<UserModel> getProfile();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      if (response.data['success'] == true) {
        return AuthResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<AuthResponseModel> register(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'email': email, 'password': password},
      );
      if (response.data['success'] == true) {
        return AuthResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get(ApiConstants.profile);
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(ApiConstants.logout);
    } on DioException {
      // Even if server logout fails, we might want to continue local logout
    }
  }
}
