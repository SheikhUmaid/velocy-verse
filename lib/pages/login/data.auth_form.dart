import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/app.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/login/component.auth_toggle.dart';
import 'package:velocyverse/components/login/component.phone_input.dart';
import 'package:velocyverse/components/login/component.social_auth_button.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/networking/notification_services.dart';
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
              onToggle: (value) {
                phoneController.clear();
                otpController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
                setState(() => isLogin = value);
              },
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
                  onTap: () async {
                    if (phoneController.text.isEmpty ||
                        phoneController.text.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(phoneController.text)) {
                      showFancyErrorToast(
                        context,
                        "Phone number must be 10 digits.",
                      );
                      return;
                    }

                    var sendOTP = await authenticationProvider.fb_sendOTP(
                      phoneController.text.trim(),
                    );
                    if (!sendOTP) {
                      print(sendOTP);
                      showFancyErrorToast(
                        context,
                        "Failed to send OTP. jefib Please try again.",
                      );
                    } else {
                      context.goNamed(
                        '/loginOTP',
                        extra: phoneController.text.trim(),
                      );
                      rootScaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text("Otp sent successfully!"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
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
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              child: Text('verify OTP'),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              isLoading: authenticationProvider.isLoading,
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
                  // if (otpController.text.isEmpty) {
                  //   showFancyErrorToast(context, "Please enter OTP.");
                  //   return;
                  // }

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

                  var sendOTP = await authenticationProvider.fb_sendOTP(
                    phoneController.text.trim(),
                  );
                  if (!sendOTP) {
                    print(sendOTP);
                    showFancyErrorToast(
                      context,
                      "Failed to send OTP. Please try again.",
                    );
                  } else {
                    context.goNamed(
                      '/registrationOTP',
                      extra: {
                        'phoneNumber': phoneController.text.trim(),
                        'otp': otpController.text.trim(),
                        'password': passwordController.text.trim(),
                        'confirmPassword': confirmPasswordController.text
                            .trim(),
                      },
                    );
                    rootScaffoldMessengerKey.currentState?.showSnackBar(
                      SnackBar(
                        content: Text("Otp sent successfully!"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }

                // //For registeration
                // if (!isLogin) {
                //   final response = await authenticationProvider.registerRequest(
                //     phoneNumber: phoneController.text,
                //     otp: otpController.text,
                //     password: passwordController.text,
                //     confirmPassword: confirmPasswordController.text,
                //   );
                //   if (response) {
                //     if (context.mounted) {
                //       context.pushNamed("/completeProfile");
                //     }
                //   } else {
                //     debugPrint("Something Went Wrong");
                //   }
                // }

                if (isLogin) {
                  context.read<LoaderProvider>().showLoader();
                  final response = await authenticationProvider
                      .loginWithPassword(
                        phoneNumber: phoneController.text,
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
    super.dispose();
  }

  Future<String?> signInWithPhone(String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    User? user = userCredential.user;

    // Get Firebase ID Token (JWT)
    String? idToken = await user?.getIdToken();
    return idToken;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  bool otpSent = false;
  bool isLoading = false;
  Future<void> sendOTP() async {
    setState(() => isLoading = true);
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOTP() async {
    if (verificationId == null) return;
    print('verifying OTP 4: ${passwordController.text}');
    print('object: $verificationId');
    setState(() => isLoading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: passwordController.text.trim(),
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user != null) {
        String? idToken = await user.getIdToken();
        print('\n\n\n=====send this $idToken to your backend');
        await sendTokenToBackend(idToken!);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid OTP: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  final ApiService _apiService = ApiService();
  Future<void> sendTokenToBackend(String idToken) async {
    final response = await _apiService.postRequest(
      "/auth_api/firebase-auth/",
      headers: {"Content-Type": "application/json"},
      data: {"idToken": idToken, 'd_token': NotificationService().fcmToken},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("sending token to backend Login success!"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("sending token to Backend error: ${response.data}"),
        ),
      );
    }
  }
}
