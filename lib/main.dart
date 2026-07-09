import 'package:finflow_app/views/http_test_screen.dart';
import 'package:finflow_app/views/profile_screen.dart';
import 'package:finflow_app/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/test_viewmodel.dart';
import 'views/auth_screen.dart';
import 'views/home_screen.dart';

void main() => runApp(const FinFlowApp());

class FinFlowApp extends StatelessWidget {
  const FinFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkLoginStatus()),
        ChangeNotifierProvider(create: (_) => TestViewModel()),
      ],
      child: MaterialApp(
        title: 'FinFlow AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthViewModel>(
            builder: (context, auth, _) {
              if (auth.isLoggedIn) {
                return const HomeScreen();
              }
              return const AuthScreen();
            },
          ),
          '/http-test': (context) => const HttpTestScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}