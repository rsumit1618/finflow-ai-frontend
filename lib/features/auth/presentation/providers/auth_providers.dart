import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/di/injection_container.dart';
import 'package:finflow_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:finflow_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:finflow_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:finflow_app/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final isLoggedInUseCaseProvider = Provider<IsLoggedInUseCase>((ref) {
  return IsLoggedInUseCase(ref.watch(authRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    getProfileUseCase: ref.watch(getProfileUseCaseProvider),
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    isLoggedInUseCase: ref.watch(isLoggedInUseCaseProvider),
  );
});
