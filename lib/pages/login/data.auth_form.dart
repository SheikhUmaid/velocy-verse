import 'package:flutter/material.dart';
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
import 'package:velocyverse/utils/util.success_toast.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with CodeAutoFill {
  bool isLogin = true;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final otpfill = SmsAutoFill();
  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void codeUpdated() {
    debugPrint("Coode UPDATED BAHE");
    setState(() {
      otpController.text = code ?? ""; // auto-filled
    });
  }

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
              onToggle: (value) {
                phoneController.clear();
                otpController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
                setState(() => isLogin = value);
              },
            ),
            const SizedBox(height: 32),
            PhoneInputField(
              controller: phoneController,
              label: 'Phone Number',
              onTenDigits: !isLogin
                  ? () async {
                      authenticationProvider.phoneNumber =
                          "+91${phoneController.text}";
                      context.read<LoaderProvider>().showLoader();
                      final res = await authenticationProvider.sendOtp(
                        mode: "register",
                      );
                      if (res) {
                        context.read<LoaderProvider>().hideLoader();
                        showFancySuccessToast(
                          context,
                          "Sent OTP to +91${phoneController.text}",
                        );
                      } else {
                        showFancyErrorToast(
                          context,
                          "Failed to send OTP, Please check the number",
                        );
                      }
                    }
                  : null,
            ),
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
                  onTap: () async {
                    final phone = phoneController.text.trim();

                    // Check if phone number is exactly 10 digits
                    if (phone.isEmpty ||
                        phone.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(phone)) {
                      showFancyErrorToast(
                        context,
                        "Enter a valid 10-digit phone number",
                      );
                      return;
                    }

                    authenticationProvider.phoneNumber = "+91$phone";
                    context.read<LoaderProvider>().showLoader();

                    final res = await authenticationProvider.sendOtp(
                      mode: "login",
                    );

                    context.read<LoaderProvider>().hideLoader();

                    if (res) {
                      if (context.mounted) {
                        context.pushNamed(
                          '/loginOTP',
                          extra: phoneController.text,
                        );
                      }
                    } else {
                      showFancyErrorToast(context, "Error sending OTP");
                    }
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
                  if (response == 'driver') {
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
    cancel(); // stop listening
    super.dispose();
  }
}
