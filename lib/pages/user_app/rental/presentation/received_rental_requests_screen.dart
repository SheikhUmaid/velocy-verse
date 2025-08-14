import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/rental/data/received_rental_requests_model.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/rental_request_rider_profile_screen.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class ReceivedRentalRequestsScreen extends StatefulWidget {
  const ReceivedRentalRequestsScreen({super.key});

  @override
  State<ReceivedRentalRequestsScreen> createState() =>
      _ReceivedRentalRequestsScreenState();
}

class _ReceivedRentalRequestsScreenState
    extends State<ReceivedRentalRequestsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RentalProvider>(
        context,
        listen: false,
      ).fetchReceivedVehilces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Received Rental Requests")),
      body: Consumer<RentalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }
          final requests = provider.receivedRentalRequest;
          if (requests.isEmpty) {
            return const Center(child: Text("No requests found"));
          }

          return RefreshIndicator(
            onRefresh: () => Provider.of<RentalProvider>(
              context,
              listen: false,
            ).fetchReceivedVehilces(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildRequestCard(context, request);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    ReceivedRentalRequestsModel request,
  ) {
    final String ip = "http://82.25.104.152/";
    final provider = Provider.of<RentalProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalRequestRiderProfileScreen(
              requestId: request.id!,
              status: request.status!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with avatar, name, reg no, and icons
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: request.userProfile != null
                      ? NetworkImage("$ip${request.userProfile!}")
                      : null,
                  child: request.userProfile == null
                      ? const Icon(Icons.person, size: 24)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.username ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        request.registrationNumber ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${request.vehicleName ?? ''} - ${request.vehicleColor ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.phone_rounded, size: 20),
                        onPressed: () {
                          if (request.phoneNumber != null) {
                            launchUrl(Uri.parse("tel:${request.phoneNumber}"));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.sms_rounded, size: 20),
                        onPressed: () {
                          if (request.phoneNumber != null) {
                            launchUrl(Uri.parse("sms:${request.phoneNumber}"));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Action buttons - Updated based on status
            if (request.status == "pending") ...[
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "Reject",
                      backgroundColor: Colors.grey[300],
                      textColor: Colors.black,
                      onPressed: provider.isSending
                          ? null
                          : () async {
                              await provider.rejectRentalRequest(request.id!);
                              if (provider.sendError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(provider.sendError!)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Request Rejected"),
                                  ),
                                );
                                await provider.fetchReceivedVehilces();
                              }
                            },
                      isLoading: provider.isSending,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: "Accept",
                      isLoading: provider.isLoading,
                      backgroundColor: Colors.grey[300],
                      textColor: Colors.black,
                      onPressed: provider.isSending
                          ? null
                          : () async {
                              await provider.acceptRentalRequest(request.id!);
                              if (provider.sendError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(provider.sendError!)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Request Accepted"),
                                  ),
                                );
                                await provider.fetchReceivedVehilces();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ] else if (request.status == "rejected") ...[
              PrimaryButton(
                text: "❌ Rejected",
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ] else if (request.status == "confirmed") ...[
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "✅Accepted",
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: "Handover",
                      isLoading: provider.isLoading,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: provider.isSending
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RentalRequestRiderProfileScreen(
                                        requestId: request.id!,
                                        status: request.status!,
                                      ),
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
