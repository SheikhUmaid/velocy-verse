import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/ride_share/presentation/shared_ride_details_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';
import 'package:velocyverse/utils/svg_image.dart';

class AvailableRidesScreen extends StatefulWidget {
  final DateTime date;
  const AvailableRidesScreen({super.key, required this.date});

  @override
  State<AvailableRidesScreen> createState() => _AvailableRidesScreenState();
}

class _AvailableRidesScreenState extends State<AvailableRidesScreen> {
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RideShareProvider>(context);
    final rides = provider.findSharingRidesModel.data;

    return Scaffold(
      appBar: AppBar(title: Text("Available Rides")),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : rides.isEmpty
          ? Center(child: Text("No rides found for ${widget.date.toLocal()}"))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child: Text(
                    widget.date.toLocal().toString().split(' ')[0],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SharedRideDetailsScreen(
                                  rideId: ride.rideId!,
                                  segmentId: ride.segmentId!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 0.6,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                        Text(
                                          "${_formatTime(ride.fromArrivalTime)} - ${_formatTime(ride.toArrivalTime)}",
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "₹${ride.segmentPrice}/seat",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.black54,
                                            size: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${ride.segmentFrom}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "${ride.segmentTo}",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    backgroundImage: ride.userProfile != null
                                        ? NetworkImage(ride.userProfile!)
                                        : null,
                                    child: ride.userProfile == null
                                        ? Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(
                                    ride.userName!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.star_rounded, size: 16),
                                      Text(
                                        ride.avgRating.toString(),
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.directions_car_filled_outlined,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.group_rounded,
                                      color: Colors.black54,
                                      size: 18,
                                    ),
                                    Text(" ${ride.joinedUsersCount} joined"),
                                  ],
                                ),
                                Divider(color: Colors.grey.shade200),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(SvgImage.bag2.value),
                                        const SizedBox(width: 8),
                                        SvgPicture.asset(SvgImage.music.value),
                                        const SizedBox(width: 8),
                                        SvgPicture.asset(SvgImage.gas.value),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.chair,
                                          size: 18,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          ride.availableSeats != 0
                                              ? " ${ride.availableSeats} Seats available"
                                              : "No Seats available",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
