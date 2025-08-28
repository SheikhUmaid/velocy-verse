import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/components/base/component.custom_text_field.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/providers/login/provider.authentication.dart';
import 'package:VelocyTaxzz/providers/provider.loader.dart';
import 'package:VelocyTaxzz/utils/util.error_toast.dart';

class LoginOTP extends StatelessWidget {
  LoginOTP({super.key, required this.phoneNumber});
  final String phoneNumber;
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Velocy")),
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
                  children: const [
                    Text(
                      "OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 44.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "The OTP has been sent to +91$phoneNumber",
                  style: const TextStyle(color: Colors.grey),
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
<<<<<<< Updated upstream
                  var verifyOTP = await authenticationProvider.fb_verifyOTP(
                    otpController.text.trim(),
                    true,
                  );
                  if (verifyOTP == 'rider') {
                    context.go('/userHome');
                  } else if (verifyOTP == 'driver') {
                    context.go('/driverMain');
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
=======
                  final otp = otpController.text.trim();

                  if (otp.isEmpty) {
                    showFancyErrorToast(context, "Please enter the OTP");
                    return;
                  }

                  // Show loader while verifying
                  context.read<LoaderProvider>().showLoader();

                  final verifyOTP = await authenticationProvider.fb_verifyOTP(
                    otp,
                    true,
                  );

                  // Hide loader
                  if (context.mounted) {
                    context.read<LoaderProvider>().hideLoader();
                  }

                  if (verifyOTP == 'rider') {
                    if (context.mounted) context.go('/userHome');
                  } else if (verifyOTP == 'driver') {
                    if (context.mounted) context.go('/driverMain');
                  } else {
                    if (context.mounted) {
                      showFancyErrorToast(context, "Invalid or expired OTP");
                    }
                  }
>>>>>>> Stashed changes
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
