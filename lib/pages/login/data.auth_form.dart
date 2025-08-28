<<<<<<< Updated upstream
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
import 'package:velocyverse/utils/util.success_toast.dart';
import 'package:sms_autofill/sms_autofill.dart';
=======
import 'package:VelocyTaxzz/services/secure_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/app.dart';
import 'package:VelocyTaxzz/components/base/component.custom_text_field.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/components/login/component.auth_toggle.dart';
import 'package:VelocyTaxzz/components/login/component.phone_input.dart';
import 'package:VelocyTaxzz/components/login/component.social_auth_button.dart';
import 'package:VelocyTaxzz/networking/apiservices.dart';
import 'package:VelocyTaxzz/networking/notification_services.dart';
import 'package:VelocyTaxzz/providers/login/provider.authentication.dart';
import 'package:VelocyTaxzz/providers/provider.loader.dart';
import 'package:VelocyTaxzz/utils/util.error_toast.dart';
import 'package:VelocyTaxzz/utils/util.is_driver.dart';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: true,
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
<<<<<<< Updated upstream
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
=======

            PhoneInputField(controller: phoneController, label: 'Phone Number'),
>>>>>>> Stashed changes
            const SizedBox(height: 24),

            CustomTextField(
              controller: passwordController,
              label: 'Password',
              placeholder: 'Enter password',
              isPassword: true,
            ),

            // ?temp
            // ElevatedButton(
            //   onPressed: _loading ? null : _sendOTP,
            //   child: Text('send OTP'),
            // ),
            if (_codeSent) ...[
              const SizedBox(height: 24),
              Text("Enter OTP sent to ${phoneController.text}"),
              CustomTextField(
                controller: _otpController,
                label: 'OTP',
                placeholder: '',
              ),
              PrimaryButton(
                onPressed: _loading ? null : _verifyOTP,
                text: 'verify OTP',
                // child: Text('verify OTP'),
              ),
            ],

            // ?

            // =============== LOGIN WITH OTP ===============
            if (isLogin) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
<<<<<<< Updated upstream
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
=======
                child: authenticationProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () async {
                          if (phoneController.text.isEmpty ||
                              phoneController.text.length != 10 ||
                              !RegExp(
                                r'^[0-9]+$',
                              ).hasMatch(phoneController.text)) {
                            showFancyErrorToast(
                              context,
                              "Phone number must be 10 digits.",
                            );
                            return;
                          }
>>>>>>> Stashed changes

                          // var sendOTP = await authenticationProvider.fb_sendOTP(
                          //   phoneController.text.trim(),
                          // );

                          // if (!sendOTP) {
                          //   showFancyErrorToast(
                          //     context,
                          //     "Failed to send OTP. Please try again.",
                          //   );
                          // } else {
                          //   // ✅ navigate only after Firebase confirms OTP was sent
                          //   if (context.mounted) {
                          //     context.goNamed(
                          //       '/loginOTP',
                          //       extra: phoneController.text.trim(),
                          //     );
                          //   }
                          //   rootScaffoldMessengerKey.currentState?.showSnackBar(
                          //     SnackBar(
                          //       content: const Text("Otp sent successfully!"),
                          //       backgroundColor: Colors.green,
                          //       behavior: SnackBarBehavior.floating,
                          //       margin: const EdgeInsets.all(16),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //     ),
                          //   );
                          // }
                          _sendOTP();
                        },
                        child: _loading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Please wait sending otp"),
                                  const SizedBox(width: 10),
                                  CircularProgressIndicator(
                                    color: Colors.green.shade800,
                                  ),
                                ],
                              )
                            : Text(
                                'Login With OTP',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                      ),
              ),
            ],

            // =============== REGISTER ===============
            if (!isLogin) ...[
              const SizedBox(height: 24),
              CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                placeholder: 'Enter password',
                isPassword: true,
              ),
            ],
<<<<<<< Updated upstream
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              child: Text('verify OTP'),
            ),
=======

>>>>>>> Stashed changes
            const SizedBox(height: 32),

            // Continue Button
            PrimaryButton(
<<<<<<< Updated upstream
              isLoading: authenticationProvider.isLoading,
=======
              isLoading: authenticationProvider.isLoading || _loading,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                  // if (otpController.text.isEmpty) {
                  //   showFancyErrorToast(context, "Please enter OTP.");
                  //   return;
                  // }

=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

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

=======

                  _sendOTP();

                  // var sendOTP = await authenticationProvider.fb_sendOTP(
                  //   phoneController.text.trim(),
                  // );
                  // if (!sendOTP) {
                  //   showFancyErrorToast(
                  //     context,
                  //     "Failed to send OTP. Please try again.",
                  //   );
                  // } else {
                  //   context.goNamed(
                  //     '/registrationOTP',
                  //     extra: {
                  //       'phoneNumber': phoneController.text.trim(),
                  //       'otp': otpController.text.trim(),
                  //       'password': passwordController.text.trim(),
                  //       'confirmPassword': confirmPasswordController.text
                  //           .trim(),
                  //     },
                  //   );
                  //   rootScaffoldMessengerKey.currentState?.showSnackBar(
                  //     SnackBar(
                  //       content: const Text("Otp sent successfully!"),
                  //       backgroundColor: Colors.green,
                  //       behavior: SnackBarBehavior.floating,
                  //       margin: const EdgeInsets.all(16),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //   );
                  // }
                }

                // Login with Password
>>>>>>> Stashed changes
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
              },
            ),
            const SizedBox(height: 24),

            // Social Auth
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

<<<<<<< Updated upstream
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
=======
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;

  /// Send OTP
  Future<void> _sendOTP() async {
    print('+91' + phoneController.text.trim());
    setState(() => _loading = true);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91' + phoneController.text.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        await _auth.signInWithCredential(credential);
        setState(() => _loading = false);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          print('code sent');
          _codeSent = true;
          _loading = false;
        });
        if (!isLogin) {
          context.goNamed(
            '/registrationOTP',
            extra: {
              'phoneNumber': phoneController.text.trim(),
              'otp': otpController.text.trim(),
              'password': passwordController.text.trim(),
              'confirmPassword': confirmPasswordController.text.trim(),
              'verificationId': verificationId,
            },
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
>>>>>>> Stashed changes
      },
    );
  }

<<<<<<< Updated upstream
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
=======
  /// Verify OTP
  Future<void> _verifyOTP() async {
    print(_otpController.text.trim());
    if (_verificationId != null) {
      setState(() => _loading = true);
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _otpController.text.trim(),
        );

        // 👇 Sign in the user with the OTP credential
        UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        // 👇 Get Firebase ID Token (JWT)
        String? idToken = await userCredential.user!.getIdToken();

        setState(() => _loading = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login successful!")));

        // ✅ Send the real ID Token (JWT) to backend
        sendTokenToBackend(idToken!);
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid OTP")));
      }
    }
  }

  final _apiService = ApiService();
  Future<String?> sendTokenToBackend(String idToken) async {
    print('id to send to backend: $idToken');
    try {
      final response = await _apiService.postRequest(
        "auth_api/firebase-auth/",
        headers: {"Content-Type": "application/json"},
        data: {
          "idToken": idToken,
          "d_token": NotificationService().fcmToken ?? "",
        },
      );

      print('Status code from backend: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final role = response.data['role'] as String?;
        final accessToken = response.data['access'] as String?;
        final refreshToken = response.data['refresh'] as String?;

        if (role != null && (role == "rider" || role == "driver")) {
          final secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'role', value: role);

          await SecureStorage.saveTokens(
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? "",
          );

          print('Role received = $role');
          if (role == 'rider') {
            if (context.mounted) context.go('/userHome');
          } else if (role == 'driver') {
            if (context.mounted) context.go('/driverMain');
          }

          return role;
        } else {
          print("Invalid role or user");
          return null;
        }
      } else {
        print("Backend rejected token. Status: ${response.statusCode}");
        return null;
      }
    } catch (e, stack) {
      print("Error in sendTokenToBackend: $e");
      print(stack);
      return null;
>>>>>>> Stashed changes
    }
  }
}
