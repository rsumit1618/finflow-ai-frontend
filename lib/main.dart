import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/localization/app_localizations.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/auth_screen.dart';
import 'views/home_screen.dart';
import 'views/http_test_screen.dart';
import 'views/profile_screen.dart';
import 'views/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkLoginStatus()),
      ],
      child: const FinFlowApp(),
    ),
  );
}

class FinFlowApp extends StatelessWidget {
  const FinFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'FinFlow AI',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getThemeData(false),
      darkTheme: themeProvider.getThemeData(true),
      themeMode: themeProvider.themeMode,
      supportedLocales: const [
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
    );
  }
}
