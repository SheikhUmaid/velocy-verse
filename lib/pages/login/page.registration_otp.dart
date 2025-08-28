<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';
import 'package:velocyverse/providers/provider.loader.dart';
import 'package:velocyverse/utils/util.error_toast.dart';
import 'package:velocyverse/utils/util.is_driver.dart';

class RegistrationOTP extends StatelessWidget {
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/components/base/component.custom_app_bar.dart';
import 'package:VelocyTaxzz/components/base/component.custom_text_field.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/providers/login/provider.authentication.dart';
import 'package:VelocyTaxzz/providers/provider.loader.dart';
import 'package:VelocyTaxzz/utils/util.error_toast.dart';
import 'package:VelocyTaxzz/utils/util.is_driver.dart';

class RegistrationOTP extends StatefulWidget {
>>>>>>> Stashed changes
  RegistrationOTP({
    super.key,
    required this.phoneNumber,
    required this.otp,
    required this.password,
    required this.confirmPassword,
<<<<<<< Updated upstream
=======
    required this.verificationId,
>>>>>>> Stashed changes
  });
  final String phoneNumber;
  final String otp;
  final String password;
  final String confirmPassword;
<<<<<<< Updated upstream
=======
  final String? verificationId;

  @override
  State<RegistrationOTP> createState() => _RegistrationOTPState();
}

class _RegistrationOTPState extends State<RegistrationOTP> {
>>>>>>> Stashed changes
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(title: Text("Velocy")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "OTP registration",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 44.00,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
<<<<<<< Updated upstream
                  "The OTP has been sent to you +91$phoneNumber",
=======
                  "The OTP has been sent to you +91${widget.phoneNumber}",
>>>>>>> Stashed changes
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              CustomTextField(
                controller: otpController,
                label: 'Enter OTP',
                placeholder: 'Enter OTP',
                isPassword: true,
              ),
<<<<<<< Updated upstream

=======
              Text("Verification ID: ${widget.verificationId}"),
>>>>>>> Stashed changes
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Continue',
                onPressed: () async {
<<<<<<< Updated upstream
                  var verifyOTP = await authenticationProvider.fb_verifyOTP(
                    otpController.text.trim(),
                    false,
                  );
                  if (verifyOTP == true) {
                    final response = await authenticationProvider
                        .registerRequest(
                          phoneNumber: phoneNumber,
                          otp: otp,
                          password: password,
                          confirmPassword: confirmPassword,
                        );
                    if (response) {
                      if (context.mounted) {
                        context.pushNamed("/completeProfile");
                      }
                    } else {
                      debugPrint("Something Went Wrong");
                    }
                  } else {
                    showFancyErrorToast(context, "Invalid OTP");
                  }
                  ;
=======
                  // if (verifyOTP == true) {
                  _verifyOTP();

                  // } else {
                  //   showFancyErrorToast(context, "Invalid OTP");
                  // }
                  // ;
>>>>>>> Stashed changes
                  // context.read<LoaderProvider>().showLoader();
                  // final response = await authenticationProvider.loginWithOTP(
                  //   phoneNumber: "+91$phoneNumber",
                  //   otp: otpController.text,
                  // );
                  // if (response) {
                  //   if (await isDriver()) {
                  //     if (context.mounted) {
                  //       context.pushNamed("/driverMain");
                  //       context.read<LoaderProvider>().hideLoader();
                  //     }
                  //   } else {
                  //     if (context.mounted) {
                  //       context.pushNamed("/userHome");
                  //       context.read<LoaderProvider>().hideLoader();
                  //     }
                  //   }
                  // } else {
                  //   showFancyErrorToast(context, "Invalid OTP");
                  //   context.read<LoaderProvider>().hideLoader();
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< Updated upstream
=======

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  /// Verify OTP
  Future<void> _verifyOTP() async {
    print("Verification ID: ${widget.verificationId}");
    print('otp entered: ${otpController.text.trim()}');
    print(otpController.text.trim());
    if (widget.verificationId != null) {
      setState(() => _loading = true);
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId!,
          smsCode: otpController.text.trim(),
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
        final response =
            await Provider.of<AuthenticationProvider>(
              context,
              listen: false,
            ).registerRequest(
              phoneNumber: widget.phoneNumber,
              otp: widget.otp,
              password: widget.password,
              confirmPassword: widget.confirmPassword,
            );
        if (response) {
          if (context.mounted) {
            context.pushNamed("/completeProfile");
          }
        } else {
          debugPrint("Something Went Wrong");
        }

        // ✅ Send the real ID Token (JWT) to backend
        // sendTokenToBackend(idToken!);
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid OTP")));
      }
    }
  }
>>>>>>> Stashed changes
}
