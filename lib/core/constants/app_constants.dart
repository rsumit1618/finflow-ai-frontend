class AppConstants {
  static const String baseUrl = 'http://16.171.113.12:3000';

  static const int connectTimeout = 60;
  static const int receiveTimeout = 60;
  static const int sendTimeout = 60;

  // Auth Endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String profile = '/api/auth/profile';
  static const String refresh = '/api/auth/refresh';

  // Upload/Document Endpoints (v1)
  static const String uploadPdf = '/api/v1/upload/pdf';
  static const String getDocuments = '/api/v1/upload/documents';

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}
