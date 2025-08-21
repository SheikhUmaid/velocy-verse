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
  RegistrationOTP({
    super.key,
    required this.phoneNumber,
    required this.otp,
    required this.password,
    required this.confirmPassword,
  });
  final String phoneNumber;
  final String otp;
  final String password;
  final String confirmPassword;
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
                  "The OTP has been sent to you +91$phoneNumber",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              CustomTextField(
                controller: otpController,
                label: 'Enter OTP',
                placeholder: 'Enter OTP',
                isPassword: true,
              ),

              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Continue',
                onPressed: () async {
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
}
