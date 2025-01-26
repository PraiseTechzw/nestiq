import 'package:flutter/material.dart';
import 'package:nestiq/services/auth_service.dart';
import 'package:nestiq/widgets/custom_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          isOutlined: true,
          onPressed: () async {
            try {
              await AuthService().signInWithGoogle();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google_logo.png',
                height: 24,
              ),
              const SizedBox(width: 12),
              const Text('Continue with Google'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CustomButton(
          isOutlined: true,
          onPressed: () async {
            try {
              await AuthService().signInWithFacebook();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/facebook_logo.png',
                height: 24,
              ),
              const SizedBox(width: 12),
              const Text('Continue with Facebook'),
            ],
          ),
        ),
      ],
    );
  }
}

