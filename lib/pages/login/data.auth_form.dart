import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/login/component.auth_toggle.dart';
import 'package:velocyverse/components/login/component.phone_input.dart';
import 'package:velocyverse/components/login/component.social_auth_button.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLogin = true;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthToggle(
              isLogin: isLogin,
              onToggle: (value) => setState(() => isLogin = value),
            ),
            const SizedBox(height: 32),
            PhoneInputField(controller: phoneController, label: 'Phone Number'),
            const SizedBox(height: 24),
            if (!isLogin) ...[
              CustomTextField(
                controller: otpController,
                label: 'OTP',
                placeholder: 'Enter OTP',
                isPassword: true,
              ),
            ],
            const SizedBox(height: 24),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              placeholder: 'Enter password',
              isPassword: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Login With OTP',
                textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
            ),
            if (!isLogin) ...[
              const SizedBox(height: 24),
              CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                placeholder: 'Enter password',
                isPassword: true,
              ),
            ],
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Continue',
              onPressed: () async {
                //For registeration
                if (!isLogin) {
                  final response = await authenticationProvider.registerRequest(
                    phoneNumber: phoneController.text,
                    otp: otpController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                  if (response) {
                    debugPrint(
                      "----------------------successfully logined----------------------",
                    );
                    if (context.mounted) {
                      context.pushNamed("/complete_profile");
                    }
                  } else {
                    debugPrint("Something Went Wrong");
                  }
                }
                print('Continue pressed');
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'or continue with',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
            const SizedBox(height: 24),
            const SocialLoginButtons(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
