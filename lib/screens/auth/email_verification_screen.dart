import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nestiq/services/auth_service.dart';
import 'package:nestiq/widgets/custom_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthService _authService = AuthService();
  Timer? _timer;
  bool _isEmailVerified = false;
  bool _canResendEmail = true;
  int _resendCooldown = 60;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    _isEmailVerified = await _authService.isEmailVerified();
    if (_isEmailVerified) {
      _timer?.cancel();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    } else {
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) async {
          await _authService.reloadUser();
          _isEmailVerified = await _authService.isEmailVerified();
          if (_isEmailVerified) {
            _timer?.cancel();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/onboarding');
            }
          }
        },
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResendEmail) return;

    try {
      await _authService.sendEmailVerification();
      setState(() {
        _canResendEmail = false;
        _resendCooldown = 60;
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_resendCooldown > 0) {
          setState(() {
            _resendCooldown--;
          });
        } else {
          setState(() {
            _canResendEmail = true;
          });
          timer.cancel();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your email',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent a verification email to your inbox. Please click the link in the email to verify your account.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomButton(
                onPressed: _canResendEmail ? _resendVerificationEmail : null,
                child: Text(
                  _canResendEmail
                      ? 'Resend Verification Email'
                      : 'Resend in $_resendCooldown seconds',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await _authService.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                child: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

