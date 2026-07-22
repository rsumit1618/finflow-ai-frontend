import 'package:dio/dio.dart';
import 'package:finflow_app/core/common/network/constants/api_constants.dart';
import 'package:finflow_app/core/common/business/errors/exceptions.dart';
import 'package:finflow_app/features/auth/data/models/auth_response.dart';
import 'package:finflow_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login({required String email, required String password});
  Future<AuthResponse> register({required String email, required String password});
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required int age,
    required String college,
    required int qualificationYear,
    required String address,
    required String highestQualification,
    String? profileImage,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponse> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        return AuthResponse.fromJson(e.response!.data as Map<String, dynamic>);
      }
      throw ServerException(e.message ?? 'Server Error');
    }
  }

  @override
  Future<AuthResponse> register({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        return AuthResponse.fromJson(e.response!.data as Map<String, dynamic>);
      }
      throw ServerException(e.message ?? 'Server Error');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get(ApiConstants.profile);
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<UserModel> updateProfile({
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
      final response = await dio.put(
        ApiConstants.profile,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'age': age,
          'college': college,
          'qualificationYear': qualificationYear,
          'address': address,
          'highestQualification': highestQualification,
          'profileImage': profileImage,
        },
      );
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(response.data['message'] ?? 'Update failed');
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
      // Ignore server logout errors
    }
  }
}
