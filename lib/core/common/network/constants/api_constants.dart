class ApiConstants {
  //static const String baseUrl = 'http://localhost:3000/api/v1'; // Dev
  static const String baseUrl = 'http://56.228.4.142:3000/api/v1'; // Prod

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static const String changePassword = '/auth/change-password';
  static const String profile = '/auth/profile';
  static const String qualifications = '/auth/qualifications';

  static const String videos = '/upload/videos';
  static String videoById(String id) => '/upload/videos/$id';
  static String videoThumbnail(String id) => '/upload/videos/$id/thumbnail';

  static const String health = '/health';
}
