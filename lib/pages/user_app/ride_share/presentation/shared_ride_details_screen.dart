import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';

class SharedRideDetailsScreen extends StatefulWidget {
  final int rideId;
  final int segmentId;

  const SharedRideDetailsScreen({
    super.key,
    required this.rideId,
    required this.segmentId,
  });

  @override
  State<SharedRideDetailsScreen> createState() =>
      _SharedRideDetailsScreenState();
}

class _SharedRideDetailsScreenState extends State<SharedRideDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<RideShareProvider>();
    provider.fetchSharedRideDetailsRequest(widget.rideId, widget.segmentId);
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("dd MMMM yyyy").format(date);
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return "-";
    try {
      final time = DateFormat("HH:mm:ss").parse(timeString);
      return DateFormat("hh:mm a").format(time);
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RideShareProvider>(context);
    final rideDetailsResponse = provider.sharedRideDetailsResponseModel;

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Ride Details")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (rideDetailsResponse == null || rideDetailsResponse.data == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Ride Details")),
        body: Center(child: Text("No ride details found.")),
      );
    }

    final shareRideDetail = rideDetailsResponse.data!;
    return Scaffold(
      appBar: AppBar(title: Text("Ride Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatDate(shareRideDetail.rideDate)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Column(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              width: 1.5,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Icon(Icons.location_on),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatTime(
                                    shareRideDetail.rideDetails?.startTime,
                                  ),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  shareRideDetail.rideDetails?.fromLocation ??
                                      "-",
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatTime(
                                    shareRideDetail.rideDetails?.endTime,
                                  ),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  shareRideDetail.rideDetails?.toLocation ??
                                      "-",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        "Duration: ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "${shareRideDetail.rideDetails!.duration!.hours}h ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "${shareRideDetail.rideDetails!.duration!.minutes}m",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Price for 1 passenger",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "₹${shareRideDetail.rideDetails!.price.toString()}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        shareRideDetail.rideCreator!.profileImage != null
                        ? NetworkImage(
                            shareRideDetail.rideCreator!.profileImage!,
                          )
                        : null,
                    child: shareRideDetail.rideCreator!.profileImage == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        shareRideDetail.rideCreator!.username ?? "Ride Creator",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(shareRideDetail.rideCreator!.avgRating.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
