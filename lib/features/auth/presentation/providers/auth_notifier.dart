import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.logoutUseCase,
    required this.isLoggedInUseCase,
  }) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Stream<String> get emailStream => _emailSubject.stream;
  Stream<String> get passwordStream => _passwordSubject.stream;

  void updateEmail(String email) => _emailSubject.add(email);
  void updatePassword(String password) => _passwordSubject.add(password);

  Future<void> checkAuthStatus() async {
    state = AuthLoading();
    final result = await isLoggedInUseCase(NoParams());
    result.fold(
      (failure) => state = AuthUnauthenticated(message: failure.message),
      (isLoggedIn) async {
        if (isLoggedIn) {
          await getProfile();
        } else {
          state = const AuthUnauthenticated();
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthError(failure.message, type: failure.type),
      (tokens) => getProfile(),
    );
  }

  Future<void> register(String email, String password) async {
    state = AuthLoading();
    final result = await registerUseCase(RegisterParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthError(failure.message, type: failure.type),
      (tokens) => getProfile(),
    );
  }

  Future<void> getProfile() async {
    final result = await getProfileUseCase(NoParams());
    result.fold(
      (failure) => state = AuthError(failure.message, type: failure.type),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    state = AuthLoading();
    final result = await updateProfileUseCase(params);
    result.fold(
      (failure) => state = AuthError(failure.message, type: failure.type),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> logout() async {
    state = AuthLoading();
    await logoutUseCase(NoParams());
    state = const AuthUnauthenticated();
  }

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    super.dispose();
  }
}
