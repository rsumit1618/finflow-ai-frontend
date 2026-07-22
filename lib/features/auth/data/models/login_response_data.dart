import 'package:finflow_app/features/auth/data/models/user_model.dart';
import 'package:finflow_app/features/auth/data/models/auth_response_model.dart';

class LoginResponseData {
  final UserModel user;
  final AuthResponseModel tokens;

  LoginResponseData({
    required this.user,
    required this.tokens,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthResponseModel.fromJson(json['tokens'] as Map<String, dynamic>),
    );
  }
}
