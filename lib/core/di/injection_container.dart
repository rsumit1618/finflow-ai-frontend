import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/infrastructure/network/api_client.dart';
import 'package:finflow_app/core/infrastructure/network/auth_interceptor.dart';
import 'package:finflow_app/core/infrastructure/storage/secure_storage.dart';
import 'package:finflow_app/features/auth/data/datasources/auth_local_datasource.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(secureStorage: ref.watch(secureStorageProvider));
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  
  // Add Logging Interceptor
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  dio.interceptors.add(AuthInterceptor(localDataSource: localDataSource, dio: dio));
  ApiClient(dio); 
  return dio;
});
