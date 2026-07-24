import 'package:flutter/material.dart';
import 'package:finflow_app/features/auth/presentation/screens/login_screen.dart';
import 'package:finflow_app/features/auth/presentation/screens/register_screen.dart';
import 'package:finflow_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:finflow_app/features/auth/presentation/screens/profile_screen.dart';
import 'package:finflow_app/features/auth/presentation/screens/update_profile_screen.dart';
import 'package:finflow_app/features/auth/presentation/screens/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String settings = '/settings';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.updateProfile:
        return MaterialPageRoute(builder: (_) => const UpdateProfileScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
