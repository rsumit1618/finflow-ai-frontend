import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/common/utils/routing/app_router.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';
import 'package:finflow_app/features/auth/presentation/screens/login_screen.dart';
import 'package:finflow_app/features/video/presentation/screens/video_list_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: 'FinFlow AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onGenerateRoute: AppRouter.generateRoute,
      home: _getHome(authState),
    );
  }

  Widget _getHome(AuthState state) {
    if (state is AuthInitial || state is AuthLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state is AuthAuthenticated) {
      return const VideoListScreen();
    }
    return const LoginScreen();
  }
}
