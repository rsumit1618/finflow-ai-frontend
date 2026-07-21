import 'package:finflow_app/core/infrastructure/storage/secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens(
      {required String accessToken, required String refreshToken});
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheTokens(
      {required String accessToken, required String refreshToken}) async {
    await secureStorage.saveAccessToken(accessToken);
    await secureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.getRefreshToken();
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.clearAll();
  }
}
