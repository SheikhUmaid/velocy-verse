import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/driver/drawerPages/profile/page.driverProfile.dart';
import 'package:velocyverse/providers/payment/provider.payment.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/providers/user/provider.rider_profile.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _customTipController = TextEditingController();

  // Trip data
  String driverName = "__";
  String carDetails = "__";
  String tripTime = "__";
  String startLocation = "__";
  String endLocation = "__";
  String? licensePlate = "__";

  // Fare breakdown
  double baseFare = 12.50;
  double distanceFare = 8.30;
  double timeFare = 6.20;
  double distance = 5.2;
  int duration = 25;

  // Tip options
  int selectedTipIndex = -1;
  double customTipAmount = 0.0;
  final List<double> tipOptions = [2, 4, 6];

  String selectedPaymentMethod = "Cash";
  bool isPromoApplied = false;
  double promoDiscount = 0.0;

  double get totalFare => baseFare + distanceFare + timeFare;
  double get selectedTip =>
      selectedTipIndex >= 0 ? tipOptions[selectedTipIndex] : customTipAmount;
  double get finalTotal => totalFare + selectedTip - promoDiscount;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _initializeRideData();
  }

  Future<void> _initializeRideData() async {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    final rideResponse = await rideProvider.driverArrivedScreen();
    final estimatedPrice = await rideProvider.estimatedPrice;

    setState(() {
      // ride = rideResponse;
      driverName = rideResponse?.data['data']['driver']['username'];
      carDetails = rideResponse?.data['data']['vehicle_name'];
      licensePlate = rideResponse?.data['data']['vehicle_number'];
      startLocation = rideProvider.fromLocation!.address.toString();
      endLocation = rideProvider.toLocation!.address;
      baseFare = estimatedPrice!;
      distanceFare = 0;
      timeFare = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    final rideResponse = Provider.of<RideProvider>(context);

    final userProvider = Provider.of<RiderProfileProvider>(context);
    // setState(() {
    //   final ride = rideResponse;
    //   driverName = ride!.data['data']['driver']['username'];
    //   carModel = ride.data['data']['vehicle_name'];
    //   licensePlate = ride.data['data']['vehicle_number'];
    // });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Ride Completed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Driver Info Section
                    Row(
                      children: [
                        // Driver Avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Driver Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${driverName}'s Ride",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                carDetails,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Trip Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tripTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Trip Route
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start Location
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                startLocation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Connecting line
                        Container(
                          margin: const EdgeInsets.only(
                            left: 5,
                            top: 4,
                            bottom: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              3,
                              (index) => Container(
                                width: 2,
                                height: 4,
                                margin: const EdgeInsets.symmetric(vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // End Location
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                endLocation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Fare Breakdown
                    const Text(
                      'Fare Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Fare Details
                    Column(
                      children: [
                        _buildFareRow(
                          'Base fare',
                          '₹${baseFare.toStringAsFixed(2)}',
                        ),

                        // _buildFareRow(
                        //   'Distance ($distance mi)',
                        //   '₹${distanceFare.toStringAsFixed(2)}',
                        // ),
                        // _buildFareRow(
                        //   'Time ($duration min)',
                        //   '₹${timeFare.toStringAsFixed(2)}',
                        // ),
                        const Divider(height: 24),

                        _buildFareRow(
                          'Total',
                          '₹${totalFare.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Promo Code Section
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            decoration: const InputDecoration(
                              hintText: 'Enter promo code',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _applyPromoCode,
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (isPromoApplied) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Promo applied! -\$${promoDiscount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Tip Section
                    // const Text(
                    //   'Tip your driver',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),

                    // const SizedBox(height: 16),

                    // // Tip Options
                    // Row(
                    //   children: [
                    //     for (int i = 0; i < tipOptions.length; i++) ...[
                    //       Expanded(
                    //         child: GestureDetector(
                    //           onTap: () => _selectTip(i),
                    //           child: Container(
                    //             height: 50,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: selectedTipIndex == i
                    //                     ? Colors.black
                    //                     : Colors.grey[300]!,
                    //                 width: selectedTipIndex == i ? 2 : 1,
                    //               ),
                    //               borderRadius: BorderRadius.circular(8),
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 '\$${tipOptions[i].toStringAsFixed(0)}',
                    //                 style: TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: selectedTipIndex == i
                    //                       ? FontWeight.w600
                    //                       : FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       if (i < tipOptions.length - 1)
                    //         const SizedBox(width: 8),
                    //     ],
                    //   ],
                    // ),
                    // const SizedBox(height: 12),

                    // Custom Tip
                    // GestureDetector(
                    //   onTap: () => _showCustomTipDialog(),
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: selectedTipIndex == -1 && customTipAmount > 0
                    //             ? Colors.black
                    //             : Colors.grey[300]!,
                    //         width: selectedTipIndex == -1 && customTipAmount > 0
                    //             ? 2
                    //             : 1,
                    //       ),
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         customTipAmount > 0
                    //             ? '\$${customTipAmount.toStringAsFixed(2)}'
                    //             : 'Custom amount',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight:
                    //               selectedTipIndex == -1 && customTipAmount > 0
                    //               ? FontWeight.w600
                    //               : FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // Bottom Payment Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Payment Method
                  GestureDetector(
                    onTap: _showPaymentOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selectedPaymentMethod == 'Cash'
                                ? Icons.money
                                : Icons.credit_card,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'pay using',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            selectedPaymentMethod,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.keyboard_arrow_up, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Pay Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        paymentProvider.openCheckout(
                          amount: finalTotal.ceil().toInt(),
                          name: "${userProvider.name}",
                          contact: userProvider.contactNumber,
                          email: userProvider.email == null
                              ? "__"
                              : userProvider.email,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 8),
                          Text(
                            '₹${(finalTotal.ceil()).toStringAsFixed(0)}', // Converting to INR for display
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _selectTip(int index) {
    setState(() {
      selectedTipIndex = index;
      customTipAmount = 0.0;
      _customTipController.clear();
    });
  }

  void _showCustomTipDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Custom Tip Amount'),
          content: TextField(
            controller: _customTipController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter amount',
              prefixText: '\$',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double amount =
                    double.tryParse(_customTipController.text) ?? 0.0;
                if (amount > 0) {
                  setState(() {
                    customTipAmount = amount;
                    selectedTipIndex = -1;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyPromoCode() {
    if (_promoController.text.isNotEmpty) {
      // Simulate promo code validation
      setState(() {
        isPromoApplied = true;
        promoDiscount = 2.50; // Example discount
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo code applied successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,

      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text('Cash'),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Cash';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Credit Card'),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Credit Card';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Digital Wallet'),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Digital Wallet';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processPayment() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Payment Successful'),
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Icon(Icons.check_circle, color: Colors.green, size: 48),
    //           const SizedBox(height: 16),
    //           Text(
    //             'Payment of \$${finalTotal.toStringAsFixed(2)} completed successfully!',
    //             textAlign: TextAlign.center,
    //           ),
    //         ],
    //       ),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //             Navigator.pop(context); // Go back to main screen
    //           },
    //           child: const Text('Done'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
