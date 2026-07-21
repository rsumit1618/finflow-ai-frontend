import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/di/injection_container.dart';
import 'package:finflow_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:finflow_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

/// Features depend on DI Container for infrastructure-level providers

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
