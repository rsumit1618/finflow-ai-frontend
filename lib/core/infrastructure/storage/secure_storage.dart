import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A Singleton service for managing secure local storage.
///
/// This class provides a centralized way to store sensitive information
/// like authentication tokens. It implements error handling and
/// singleton patterns for resource efficiency.
class SecureStorage {
  // 1. Private constructor for Singleton
  SecureStorage._internal();

  // 2. The single instance
  static final SecureStorage _instance = SecureStorage._internal();

  // 3. Factory constructor to return the same instance
  factory SecureStorage() => _instance;

  // Internal storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Constants for keys
  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';

  /// Saves the access token securely.
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      debugPrint('SecureStorage Error (saveAccessToken): $e');
      rethrow;
    }
  }

  /// Saves the refresh token securely.
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      debugPrint('SecureStorage Error (saveRefreshToken): $e');
      rethrow;
    }
  }

  /// Retrieves the cached access token.
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      debugPrint('SecureStorage Error (getAccessToken): $e');
      return null;
    }
  }

  /// Retrieves the cached refresh token.
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      debugPrint('SecureStorage Error (getRefreshToken): $e');
      return null;
    }
  }

  /// Clears all stored tokens (e.g., on logout).
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('SecureStorage Error (clearAll): $e');
      rethrow;
    }
  }

  /// Deletes a specific key.
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('SecureStorage Error (delete $key): $e');
    }
  }
}
