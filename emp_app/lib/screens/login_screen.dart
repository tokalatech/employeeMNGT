import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'app_shell.dart';

import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.onThemeToggle});

  final VoidCallback onThemeToggle;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _signup = false;
  bool _showPassword = false;
  bool _loading = false;
  bool _rememberMe = true, _agreeTerms = true, _manager = false;
  String? _error;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  final _dob = TextEditingController();
  final _address = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  String _department = 'Engineering';

  Future<T> _completeWithin<T>(Future<T> operation, String timeoutMessage) {
    return operation.timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw StateError(timeoutMessage),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _confirm.dispose();
    _phone.dispose();
    _dob.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dob.text =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    final name = _name.text.trim();
    final confirmPassword = _confirm.text;
    final phone = _phone.text.trim();
    final dob = _dob.text.trim();
    final address = _address.text.trim();

    // Common validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Please enter your email and password.';
      });
      return;
    }

    // Signup validation
    if (_signup) {
      if (name.isEmpty) {
        setState(() {
          _error = 'Please enter your full name.';
        });
        return;
      }

      if (!email.contains('@')) {
        setState(() {
          _error = 'Please enter a valid email address.';
        });
        return;
      }

      if (password.length < 6) {
        setState(() {
          _error = 'Password must be at least 6 characters.';
        });
        return;
      }

      if (password != confirmPassword) {
        setState(() {
          _error = 'Passwords do not match.';
        });
        return;
      }

      if (!_agreeTerms) {
        setState(() {
          _error = 'Please agree to the Terms of Service.';
        });
        return;
      }
      if (phone.isEmpty) {
        setState(() {
          _error = 'Please enter your phone number.';
        });
        return;
      }
      if (dob.isEmpty) {
        setState(() {
          _error = 'Please select your date of birth.';
        });
        return;
      }
      if (address.isEmpty) {
        setState(() {
          _error = 'Please enter your address.';
        });
        return;
      }
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      if (_signup) {
        // --------------------------------------------------
        // 1. Create Firebase Authentication account
        // --------------------------------------------------
        final credential = await _completeWithin(
          _authService.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
          'Account creation timed out. Please check your internet connection.',
        );

        final firebaseUser = credential.user;

        if (firebaseUser == null) {
          throw StateError('Unable to create user account.');
        }

        // --------------------------------------------------
        // 2. Update Firebase Auth display name
        // --------------------------------------------------
        await _completeWithin(
          firebaseUser.updateDisplayName(name),
          'Account was created, but updating the profile timed out.',
        );

        // --------------------------------------------------
        // 3. Create UserModel for Firestore
        // --------------------------------------------------
        final user = UserModel(
          id: firebaseUser.uid,
          name: name,
          email: email,
          phone: phone,
          dob: dob,
          address: address,
          avatar: '',
          designation: _manager ? 'Manager' : 'Employee',
          department: _department,
          employeeId: 'EMP-${firebaseUser.uid.substring(0, 6).toUpperCase()}',
          role: _manager ? UserRole.manager : UserRole.employee,
          joiningDate: DateTime.now().toIso8601String().split('T').first,
          employmentType: 'Full-time',
        );

        // --------------------------------------------------
        // 4. Save UserModel into Firestore
        // --------------------------------------------------
        await _completeWithin(
          _userService.createOrUpdateUser(user),
          'Account was created, but saving the employee profile timed out.',
        );
      } else {
        // --------------------------------------------------
        // Login
        // --------------------------------------------------
        await _completeWithin(
          _authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          'Sign in timed out. Please check your internet connection.',
        );
      }

      if (!mounted) return;

      // --------------------------------------------------
      // 5. Open AppShell
      // --------------------------------------------------
      // Always resolve the manager flag from the account's actual Firestore
      // role rather than the sign-up form's local toggle — otherwise every
      // normal login (not just sign-up) would show the employee view even
      // for manager accounts.
      bool isManager = _signup && _manager;
      if (!_signup) {
        final profile = await _completeWithin(
          _userService.getCurrentUser(),
          'Sign in succeeded, but loading your employee profile timed out.',
        );
        if (profile == null) {
          throw StateError(
            'Your account does not have an employee profile. Please contact an administrator.',
          );
        }
        isManager = profile.role == UserRole.manager;
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => AppShell(
            onThemeToggle: widget.onThemeToggle,
            initialManager: isManager,
          ),
        ),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'wrong-password':
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;

        case 'email-already-in-use':
          message = 'An account already exists with this email.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = e.message ?? 'Authentication failed.';
      }

      if (mounted) {
        setState(() {
          _error = message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Bad state: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _sendPasswordReset() async {
    final email = _email.text.trim();

    if (email.isEmpty) {
      setState(() {
        _error = 'Please enter your email first.';
      });
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link has been sent to your email.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message ?? 'Unable to send password reset email.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _signup ? 'Create Employee Account' : 'Welcome Back',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _signup
                        ? 'Register your employee profile to get instant access to PulseHR'
                        : 'Sign in to access your attendance, leaves, and payslips',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  _modeSelector(context),
                  const SizedBox(height: 14),
                  PulseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_signup) ...[
                          _field(_name, 'Full Name', Icons.person_outline),
                          const SizedBox(height: 12),
                          _field(_phone, 'Phone Number', Icons.phone_outlined),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _dob,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            onTap: _selectDateOfBirth,
                          ),
                          const SizedBox(height: 12),

                          _field(
                            _address,
                            'Address',
                            Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 12),
                        ],
                        _field(
                          _email,
                          // 'Email or Employee ID',
                          'Email',
                          Icons.mail_outline,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _password,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: _signup ? 'Create Password' : 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                        if (_signup) ...[
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: 'Engineering',
                            decoration: const InputDecoration(
                              labelText: 'Department',
                              prefixIcon: Icon(Icons.apartment_outlined),
                            ),
                            items:
                                const [
                                      'Engineering',
                                      'Product & Design',
                                      'Human Resources',
                                      'Finance',
                                    ]
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _department = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(
                                value: false,
                                label: Text('Employee'),
                              ),
                              ButtonSegment(
                                value: true,
                                label: Text('Manager'),
                              ),
                            ],
                            selected: {_manager},
                            onSelectionChanged: _loading
                                ? null
                                : (value) =>
                                      setState(() => _manager = value.first),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _confirm,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _agreeTerms,
                            onChanged: (value) =>
                                setState(() => _agreeTerms = value ?? false),
                            title: const Text(
                              'I agree to the Terms of Service',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                        if (!_signup) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _sendPasswordReset,
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _rememberMe,
                            onChanged: (value) =>
                                setState(() => _rememberMe = value ?? false),
                            title: const Text(
                              'Remember me',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                        if (_error != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4E6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: AppColors.danger,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        PrimaryButton(
                          label: _loading
                              ? 'Please wait...'
                              : (_signup
                                    ? 'Create Account'
                                    : 'Sign In Securely'),
                          onPressed: _loading ? null : _submit,
                          icon: _signup
                              ? Icons.person_add_alt_1
                              : Icons.arrow_forward,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => setState(() => _signup = !_signup),
                    child: Text(
                      _signup
                          ? 'Already have an account? Sign In'
                          : 'New to PulseHR? Create Account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
  ) => TextField(
    controller: controller,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
  );

  Widget _modeSelector(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Expanded(
          child: _modeButton(
            context,
            'Sign In',
            !_signup,
            () => setState(() => _signup = false),
          ),
        ),
        Expanded(
          child: _modeButton(
            context,
            'Sign Up',
            _signup,
            () => setState(() => _signup = true),
          ),
        ),
      ],
    ),
  );

  Widget _modeButton(
    BuildContext context,
    String text,
    bool active,
    VoidCallback onTap,
  ) => TextButton(
    onPressed: _loading ? null : onTap,
    style: TextButton.styleFrom(
      backgroundColor: active ? Theme.of(context).colorScheme.surface : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: active ? AppColors.primary : null,
      ),
    ),
  );
}
