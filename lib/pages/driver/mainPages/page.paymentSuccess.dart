import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PaymentStatusScreen extends StatefulWidget {
  PaymentStatusScreen({super.key});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build called");
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animate: true, "assets/animations/payment_done.json"),
          Text("Payment Completed"),
        ],
      ),
      floatingActionButton: OutlinedButton(
        onPressed: () {
          context.goNamed('/loading');
        },
        child: Text("Done"),
      ),
    );
  }
}
