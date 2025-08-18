import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// import 'package:web_socket_channel/web_socket_channel.dart';
enum PaymentStatus { idle, success, failure }

class PaymentProvider with ChangeNotifier {
  late Razorpay _razorpay;
  PaymentStatus status = PaymentStatus.idle;
  PaymentProvider() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  VoidCallback? paymentCompleted;
  VoidCallback? paymentError;

  void openCheckout({
    required int amount,
    required String name,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': 'rzp_test_qG5IEPdkYFHo3N',
      'amount': amount * 100,
      'name': name,
      'description': 'Order Payment',
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
      'theme': {'color': '#000000'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error opening Razorpay: $e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Successful: ${response.paymentId}");
    status = PaymentStatus.success;
    notifyListeners();
    paymentCompleted!();
    // You can notify UI or call API to verify payment
  }

  void handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.code} - ${response.message}");
    status = PaymentStatus.failure;
    notifyListeners();
    paymentError!();
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
