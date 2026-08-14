import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class PulseHrApp extends StatefulWidget {
  const PulseHrApp({super.key});

  @override
  State<PulseHrApp> createState() => _PulseHrAppState();
}

/// Backwards-compatible app name used by Flutter's generated widget test.
class MyApp extends PulseHrApp {
  const MyApp({super.key});
}

class _PulseHrAppState extends State<PulseHrApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() => setState(() {
        _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      });

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pulse HRMS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: SplashScreen(onThemeToggle: _toggleTheme),
      );
}
