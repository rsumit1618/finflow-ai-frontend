import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

/// StateNotifier managing authentication state using Riverpod.
///
/// Handles login, register, logout, token-based session restoration,
/// and profile fetching. Errors from profile fetch after login are now
/// properly propagated as [AuthError] instead of silently falling back to
/// [AuthUnauthenticated].
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  // RxDart subjects for internal reactive logic if needed
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  AuthNotifier(this._repository) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Stream<String> get emailStream => _emailSubject.stream;
  Stream<String> get passwordStream => _passwordSubject.stream;

  void updateEmail(String email) => _emailSubject.add(email);
  void updatePassword(String password) => _passwordSubject.add(password);

  /// Checks if the user has a valid stored session token.
  /// If yes, tries to fetch profile; otherwise shows unauthenticated state.
  Future<void> checkAuthStatus() async {
    state = AuthLoading();
    final result = await _repository.isLoggedIn();
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

  /// Authenticates user with email and password.
  /// On success, fetches profile. On failure, shows [AuthError] with message.
  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (tokens) => getProfile(),
    );
  }

  /// Registers a new user with email and password.
  /// On success, fetches profile. On failure, shows [AuthError] with message.
  Future<void> register(String email, String password) async {
    state = AuthLoading();
    final result = await _repository.register(email: email, password: password);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (tokens) => getProfile(),
    );
  }

  /// Fetches the authenticated user's profile.
  /// On failure, sets [AuthError] (previously was [AuthUnauthenticated] — fixed).
  Future<void> getProfile() async {
    final result = await _repository.getProfile();
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  /// Logs the user out, clears tokens, and sets [AuthUnauthenticated].
  Future<void> logout() async {
    state = AuthLoading();
    await _repository.logout();
    state = const AuthUnauthenticated();
  }

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    super.dispose();
  }
}
