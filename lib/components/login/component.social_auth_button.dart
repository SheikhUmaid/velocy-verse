import 'package:flutter/material.dart';
import 'package:velocyverse/utils/util.error_toast.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});
  void _featureNotReady(BuildContext context) {
    showFancyErrorToast(context, "We will notify once this feature is active");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SocialButton(
          icon: Icons.g_mobiledata,
          onPressed: () {
            // Handle Google login
            _featureNotReady(context);
            print('Google login pressed');
          },
        ),
        SocialButton(
          icon: Icons.apple,
          onPressed: () {
            // Handle Apple login
            _featureNotReady(context);
            print('Apple login pressed');
          },
        ),
        SocialButton(
          icon: Icons.facebook,
          onPressed: () {
            // Handle Facebook login
            _featureNotReady(context);
            print('Facebook login pressed');
          },
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: Colors.black),
      ),
    );
  }
}
