import 'dart:async';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onThemeToggle});

  final VoidCallback onThemeToggle;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1100), _routeNext);
  }

  Future<void> _routeNext() async {
    // Firebase Auth persists the session between app launches. Without this
    // check, every restart forces a fresh login even for an already
    // signed-in user.
    if (!_authService.isSignedIn) {
      _goTo(LoginScreen(onThemeToggle: widget.onThemeToggle));
      return;
    }

    UserModel? profile;
    try {
      profile = await _userService.getCurrentUser();
    } catch (_) {
      profile = null;
    }

    if (!mounted) return;

    if (profile == null) {
      // Signed in with Firebase Auth but no matching Firestore profile
      // (e.g. account was deleted server-side) — fall back to login.
      _goTo(LoginScreen(onThemeToggle: widget.onThemeToggle));
      return;
    }

    _goTo(AppShell(
      onThemeToggle: widget.onThemeToggle,
      initialManager: profile.role == UserRole.manager,
    ));
  }

  void _goTo(Widget page) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/logo.jpg',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              const Text(
                'PulseHR Mobile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enterprise Employee Self-Service',
                style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 12),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 9,
                    height: 9,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Connecting to HRMS Cloud Engine...',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
