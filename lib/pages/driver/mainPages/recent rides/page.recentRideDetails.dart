import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/models/model.recentRideModel.dart';
import 'package:VelocyTaxzz/providers/driver/provider.rideHistory.dart';

class RecentRideDetails extends StatefulWidget {
  const RecentRideDetails({Key? key, required this.rideId}) : super(key: key);
  final String rideId;
  @override
  State<RecentRideDetails> createState() => _RecentRideDetailsState();
}

class _RecentRideDetailsState extends State<RecentRideDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<RecentRidesProvider>(
        context,
        listen: false,
      ).fetchRideDetails(widget.rideId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider = Provider.of<RecentRidesProvider>(context);
    final ride = detailsProvider.rideDetails?.data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: detailsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ride == null
          ? const Center(child: Text("No details found"))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildRideCard(ride),
                        const SizedBox(height: 32),
                        _buildDriverDetails(ride),
                        const SizedBox(height: 32),
                        _buildRideStats(ride),
                        const SizedBox(height: 100), // bottom space
                      ],
                    ),
                  ),
                ),
                // _buildBottomSection(),
              ],
            ),
    );
  }

  Widget _buildRideCard(Data ride) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ride.startTime ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomPaint(painter: DottedLinePainter()),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ride.fromLocation?.address ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildInfoPill(
                          "Payment",
                          "₹${ride.creditedAmount ?? 0}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ride.toLocation?.address ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildInfoPill(
                          "Distance",
                          "${ride.distanceKm ?? 0} km",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverDetails(Data ride) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rider Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage: ride.rider?.profileImage != null
                  ? NetworkImage(ride.rider!.profileImage!)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.rider?.username ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    double rating = (ride.rider?.ratingReview ?? 0).toDouble();
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: index < rating ? Colors.orange : Colors.grey[400],
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRideStats(Data ride) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ride.paymentMethod ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time Duration',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ride.duration ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildBottomSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 8,
  //           offset: const Offset(0, -2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Container(
  //           width: 40,
  //           height: 4,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[400],
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         SizedBox(
  //           width: double.infinity,
  //           child: ElevatedButton(
  //             onPressed: () {
  //               // Handle cancel action
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.black,
  //               elevation: 0,
  //               padding: const EdgeInsets.symmetric(vertical: 16),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //             ),
  //             child: const Text(
  //               'Cancel',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 3.0;
    const dashSpace = 2.0;
    double startY = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2.0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
