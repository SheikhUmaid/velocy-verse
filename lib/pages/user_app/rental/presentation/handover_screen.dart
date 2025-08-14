import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class HandoverScreen extends StatefulWidget {
  final int requestId;
  const HandoverScreen({super.key, required this.requestId});

  @override
  State<HandoverScreen> createState() => _HandoverScreenState();
}

class _HandoverScreenState extends State<HandoverScreen> {
  bool carKeys = false;
  bool vehicleDocs = false;
  bool fuelFull = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<RentalProvider>(context, listen: false);
      await provider.fetchHandoverOwnerDetails(widget.requestId);
      final handover = provider.handoverModel;
      if (handover != null) {
        setState(() {
          carKeys = handover.handedOverCarKeys ?? false;
          vehicleDocs = handover.handedOverVehicleDocuments ?? false;
          fuelFull = handover.fuelTankFull ?? false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Car Handover")),
      body: Consumer<RentalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          final handover = provider.handoverModel;
          if (handover == null) {
            return const Center(child: Text("No details found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Vehicle card
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: handover.vehicleImage != null
                              ? DecorationImage(
                                  image: NetworkImage(handover.vehicleImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: handover.vehicleImage == null
                            ? const Icon(
                                Icons.directions_car,
                                size: 28,
                                color: Colors.grey,
                              )
                            : null,
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
                            // Text(
                            //   "License: ${handover.licenseDocument ?? ''}",
                            //   style: const TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Handover checklist
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _sectionTitle("Handover Checklist"),
                      _checkTile("Car Keys", carKeys, (val) {
                        setState(() => carKeys = val);
                      }),
                      _checkTile("Vehicle Documents", vehicleDocs, (val) {
                        setState(() => vehicleDocs = val);
                      }),
                      _checkTile("Fuel Tank Full", fuelFull, (val) {
                        setState(() => fuelFull = val);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Payment details
                Container(
                  color: Colors.white,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<RentalProvider>(
          builder: (context, provider, _) {
            return PrimaryButton(
              text: provider.isLoading ? "Submitting..." : "Confirm Handover",
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      await provider.submitHandoverDetails(
                        widget.requestId,
                        carKeys,
                        vehicleDocs,
                        fuelFull,
                      );

                      if (provider.isSuccess) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text(
                        //       "Handover details submitted successfully!",
                        //     ),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.black,
                                  size: 60,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Handover details submitted successfully!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 25),
                                PrimaryButton(
                                  text: "Ok",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                        // Navigator.popUntil(context, ModalRoute.withName('/rental'));
                      } else if (provider.sendError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.sendError!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
            );
          },
        ),
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

  Widget _checkTile(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      checkColor: Colors.white,
      activeColor: Colors.black,
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(title, style: const TextStyle(fontSize: 14)),
    );
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
}
