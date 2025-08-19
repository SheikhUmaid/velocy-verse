import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/ride_share/presentation/available_rides_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';

class RideShareScreen extends StatefulWidget {
  const RideShareScreen({super.key});

  @override
  State<RideShareScreen> createState() => _RideShareScreenState();
}

class _RideShareScreenState extends State<RideShareScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  int seats = 1;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isLoading = false;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String get formattedDate {
    final today = DateTime.now();
    if (selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day) {
      return "Today";
    }
    return DateFormat('EEE, MMM d').format(selectedDate);
  }

  String get formattedTime {
    final now = TimeOfDay.now();
    if (selectedTime.hour == now.hour && selectedTime.minute == now.minute) {
      return "Now";
    }
    return selectedTime.format(context);
  }

  void _findRide() async {
    final provider = context.read<RideShareProvider>();
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both locations")),
      );
      return;
    }

    setState(() => isLoading = true);

    await provider.fetchAvailableRidesRequest(from, to, selectedDate, seats);

    setState(() => isLoading = false);

    if (provider.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${provider.error}")));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvailableRidesScreen(date: selectedDate),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Ride Share"),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline_rounded, color: Colors.black),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
            onPressed: () {},
            label: Text("Publish", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // First Section (Leaving & Going)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _fromController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.circle,
                        size: 14,
                        color: Colors.black,
                      ),
                      hintText: "Leaving from",
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: "Going to",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Second Section (Seats, Date, Time)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number of Seats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Number of Seats",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                if (seats > 1) {
                                  setState(() => seats--);
                                }
                              },
                              child: const Icon(Icons.remove_rounded),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            seats.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() => seats++);
                              },
                              child: Icon(Icons.add_rounded),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Date", style: TextStyle(fontSize: 16)),
                      TextButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.black,
                        ),
                        label: Text(
                          formattedDate,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Time", style: TextStyle(fontSize: 16)),
                      TextButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.black,
                        ),
                        label: Text(
                          formattedTime,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: isLoading ? "Searching..." : "Find a Ride",
          onPressed: isLoading ? null : _findRide,
        ),
      ),
    );
  }
}

// class RideShareScreen extends StatelessWidget {
//   const RideShareScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Icon
//                       Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white24, width: 2),
//                         ),
//                         child: const Icon(
//                           Icons.groups_rounded,
//                           size: 48,
//                           color: Colors.white,
//                         ),
//                       ),

//                       const SizedBox(height: 48),

//                       // Title
//                       const Text(
//                         'Ride Share',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: -0.5,
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // Subtitle
//                       const Text(
//                         'Connect with people\ngoing your way',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white54,
//                           fontSize: 16,
//                           height: 1.5,
//                         ),
//                       ),

//                       const SizedBox(height: 64),

//                       // Coming soon container
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 20,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.white24),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Text(
//                           'COMING SOON',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 2.0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
