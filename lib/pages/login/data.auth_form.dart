import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/login/component.auth_toggle.dart';
import 'package:velocyverse/components/login/component.phone_input.dart';
import 'package:velocyverse/components/login/component.social_auth_button.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';
import 'package:velocyverse/providers/provider.loader.dart';
import 'package:velocyverse/utils/util.error_toast.dart';
import 'package:velocyverse/utils/util.is_driver.dart';

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
            if (isLogin) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    context.pushNamed('/loginOTP', extra: phoneController.text);
                  },
                  child: const Text(
                    'Login With OTP',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  ),
                ),
              ),
            ],
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
                // Basic Validations
                if (phoneController.text.isEmpty ||
                    phoneController.text.length != 10 ||
                    !RegExp(r'^[0-9]+$').hasMatch(phoneController.text)) {
                  showFancyErrorToast(
                    context,
                    "Phone number must be 10 digits.",
                  );
                  return;
                }

                if (passwordController.text.isEmpty ||
                    passwordController.text.length < 6) {
                  showFancyErrorToast(
                    context,
                    "Password must be at least 6 characters.",
                  );
                  return;
                }

                // Registration-specific validations
                if (!isLogin) {
                  if (otpController.text.isEmpty) {
                    showFancyErrorToast(context, "Please enter OTP.");
                    return;
                  }

                  if (confirmPasswordController.text.isEmpty) {
                    showFancyErrorToast(
                      context,
                      "Please confirm your password.",
                    );
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    showFancyErrorToast(context, "Passwords do not match.");
                    return;
                  }
                }

                //For registeration
                if (!isLogin) {
                  final response = await authenticationProvider.registerRequest(
                    phoneNumber: phoneController.text,
                    otp: otpController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                  if (response) {
                    if (context.mounted) {
                      context.pushNamed("/completeProfile");
                    }
                  } else {
                    debugPrint("Something Went Wrong");
                  }
                }

                if (isLogin) {
                  context.read<LoaderProvider>().showLoader();
                  final response = await authenticationProvider
                      .loginWithPassword(
                        phoneNumber: "+91${phoneController.text}",
                        password: passwordController.text,
                      );
                  if (response) {
                    if (await isDriver()) {
                      if (context.mounted) {
                        context.pushNamed("/driverMain");
                        context.read<LoaderProvider>().hideLoader();
                      }
                    } else {
                      if (context.mounted) {
                        context.pushNamed("/userHome");
                        context.read<LoaderProvider>().hideLoader();
                      }
                    }
                  } else {
                    debugPrint("Something Went Wrong");
                    context.read<LoaderProvider>().hideLoader();
                    showFancyErrorToast(
                      context,
                      "Seems like you have put invalid credentials",
                    );
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
