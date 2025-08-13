import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentProvider with ChangeNotifier {
  late Razorpay _razorpay;

  PaymentProvider() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Successful: ${response.paymentId}");
    // You can notify UI or call API to verify payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
