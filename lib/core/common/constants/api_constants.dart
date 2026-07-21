/// Centralized API configuration constants.
///
/// Single source of truth for all API endpoints and configuration.
class ApiConstants {
  /// Base URL - Switch between dev and production
  static const String baseUrl = 'http://localhost:3000/api/v1'; // Dev
  // static const String baseUrl = 'http://16.171.113.12:3000/api/v1'; // Prod

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Storage keys
  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String refreshTokenKey = 'REFRESH_TOKEN';

  // Auth Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static const String changePassword = '/auth/change-password';
  static const String profile = '/auth/profile';
  static const String qualifications = '/auth/qualifications';

  // Video/Upload Endpoints
  static const String videos = '/upload/videos';
  static String videoById(String id) => '/upload/videos/$id';
  static String videoThumbnail(String id) => '/upload/videos/$id/thumbnail';

  // Document Endpoints (v1)
  static const String uploadPdf = '/upload/pdf';
  static const String getDocuments = '/upload/documents';

  // Health
  static const String health = '/health';
}
