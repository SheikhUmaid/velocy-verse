import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class RiderPickupHandoverScreen extends StatefulWidget {
  final int requestId;
  const RiderPickupHandoverScreen({super.key, required this.requestId});

  @override
  State<RiderPickupHandoverScreen> createState() =>
      _RiderPickupHandoverScreenState();
}

class _RiderPickupHandoverScreenState extends State<RiderPickupHandoverScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<RentalProvider>(context, listen: false);
      await provider.fetchHandoverRiderDetails(widget.requestId);
      final handover = provider.riderHandoverModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String ip = "http://82.25.104.152/";
    return Scaffold(
      appBar: AppBar(title: Text("Handover Details")),
      body: Consumer<RentalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          final handover = provider.riderHandoverModel;
          if (handover == null) {
            return const Center(child: Text("No details found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          // image: handover.vehicleImage != null
                          //     ? DecorationImage(
                          //         image: NetworkImage(
                          //           "$ip${handover.vehicleImage!}",
                          //         ),
                          //         fit: BoxFit.cover,
                          //       )
                          //     : null,
                        ),
                        // child: handover.vehicleImage == null
                        //     ? const Icon(
                        //         Icons.directions_car,
                        //         size: 28,
                        //         color: Colors.grey,
                        //       )
                        //     : null,
                        child: const Icon(
                          Icons.directions_car,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              handover.vehicleName ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              handover.registrationNumber ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _sectionTitle("Handover Checklist"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            handover.handedOverCarKeys!
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Car Keys",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(
                            handover.handedOverVehicleDocuments!
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          SizedBox(width: 8),
                          Text("Vehicle Documents"),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(
                            handover.fuelTankFull!
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          SizedBox(width: 8),
                          Text("Fuel Tank Full"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle("Payment Details"),
                      _paymentRow("Rental Fee", handover.totalRentPrice ?? "0"),
                      _paymentRow(
                        "Security Deposit",
                        handover.securityDeposite ?? "0",
                      ),
                      Divider(),
                      _paymentRow(
                        "Total Amount",
                        ((double.tryParse(handover.totalRentPrice ?? "0") ??
                                    0) +
                                (double.tryParse(
                                      handover.securityDeposite ?? "0",
                                    ) ??
                                    0))
                            .toStringAsFixed(2),
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _paymentRow(String label, String amount, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "₹$amount",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Widget _sectionTitle(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    ),
  );
}
