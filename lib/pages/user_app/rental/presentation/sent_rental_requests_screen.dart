import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/rental/data/sent_rental_request_model.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/rider_pickup_handover_screen.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';
import 'package:velocyverse/utils/responsive_wraper.dart';
import 'package:velocyverse/utils/util.error_toast.dart';
import 'package:velocyverse/utils/util.success_toast.dart';

class SentRentalRequestsScreen extends StatefulWidget {
  const SentRentalRequestsScreen({super.key});

  @override
  State<SentRentalRequestsScreen> createState() =>
      _SentRentalRequestsScreenState();
}

class _SentRentalRequestsScreenState extends State<SentRentalRequestsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RentalProvider>(
        context,
        listen: false,
      ).fetchSentRentalRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sent Requests")),
      body: ResponsiveWraper(
        child: Consumer<RentalProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.sentRentalRequests.isEmpty) {
              return const Center(child: Text("No sent rental requests."));
            }

            return RefreshIndicator(
              onRefresh: () => Provider.of<RentalProvider>(
                context,
                listen: false,
              ).fetchSentRentalRequests(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: provider.sentRentalRequests.length,
                itemBuilder: (context, index) {
                  final SentRentalRequestModel request =
                      provider.sentRentalRequests[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row with Request ID & Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Request #${request.id}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  request.status == "pending"
                                      ? "Wating for Approval"
                                      : "Approved",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: request.status == "pending"
                                        ? Colors.black
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // User Info
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color.fromARGB(
                                  255,
                                  209,
                                  209,
                                  209,
                                ),
                                radius: 22,
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request.lessorUsername ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "ID: USR-${request.id}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Vehicle Details
                          const Text(
                            "Vehicle Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildKeyValueRow(
                            "Vehicle Number",
                            request.registrationNumber ?? '',
                          ),
                          _buildKeyValueRow("Model", request.vehicleName ?? ''),
                          const SizedBox(height: 16),

                          // Rental Period
                          const Text(
                            "Rental Period",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildKeyValueRow("Start Date", request.pickup ?? ''),
                          _buildKeyValueRow("End Date", request.dropoff ?? ''),
                          _buildKeyValueRow(
                            "Duration",
                            _getDurationString(request.durationHours),
                          ),
                          const SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      request.status?.toLowerCase() ==
                                          "cancelled"
                                      ? null // disables button
                                      : () async {
                                          final provider =
                                              Provider.of<RentalProvider>(
                                                context,
                                                listen: false,
                                              );
                                          await provider.cancelRequest(
                                            request.id!,
                                          );
                                          await provider
                                              .fetchSentRentalRequests();
                                          if (provider.sendError != null) {
                                            showFancyErrorToast(
                                              context,
                                              "Failed to cancel rental request",
                                            );
                                            // ScaffoldMessenger.of(
                                            //   context,
                                            // ).showSnackBar(
                                            //   SnackBar(
                                            //     content: Text(
                                            //       provider.sendError!,
                                            //     ),
                                            //   ),
                                            // );
                                          } else {
                                            showFancySuccessToast(
                                              context,
                                              'Renatl request cancelled successfully',
                                            );
                                            // ScaffoldMessenger.of(
                                            //   context,
                                            // ).showSnackBar(
                                            //   const SnackBar(
                                            //     content: Text(
                                            //       'Renatl request cancelled successfully',
                                            //     ),
                                            //   ),
                                            // );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        request.status?.toLowerCase() ==
                                            "cancelled"
                                        ? Colors.grey
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    request.status?.toLowerCase() == "cancelled"
                                        ? "Cancelled"
                                        : "Cancel Request",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              if (request.status?.toLowerCase() != "pending" &&
                                  request.status?.toLowerCase() !=
                                      "cancelled") ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RiderPickupHandoverScreen(
                                                requestId: request.id!,
                                              ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Pick Up",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getDurationString(int? hours) {
    if (hours == null) return '';
    if (hours % 24 == 0) {
      return "${hours ~/ 24} days";
    }
    return "$hours hours";
  }
}
