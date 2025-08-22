import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/my_garage_screen.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/received_rental_requests_screen.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/rental_vehicle_details_screen.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/sent_rental_requests_screen.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class RentalScreen extends StatefulWidget {
  const RentalScreen({super.key});

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = ["All", "SUV", "Sedan", "Hatchback"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RentalProvider>(context, listen: false).fetchRentalVehicles();
    });
  }

  Future<void> _onRefresh() async {
    await Provider.of<RentalProvider>(
      context,
      listen: false,
    ).fetchRentalVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(title: const Text("Rental")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top Buttons
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SentRentalRequestsScreen(),
                        ),
                      ),
                      text: "Sent Requests",
                      textColor: Colors.black,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: "Receive Requests",
                      textColor: Colors.black,
                      backgroundColor: Colors.grey.shade300,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceivedRentalRequestsScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // My Garage Button
              PrimaryButton(
                width: double.infinity,
                text: "My Garage",
                backgroundColor: Colors.grey.shade300,
                textColor: Colors.black,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyGarageScreen()),
                ),
              ),
              const SizedBox(height: 10),

              // TabBar
              TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.black,
                tabs: tabs.map((t) => Tab(text: t)).toList(),
              ),

              // Tab Views
              Expanded(
                child: Consumer<RentalProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.error != null) {
                      return Center(child: Text("Error: ${provider.error}"));
                    }
                    return TabBarView(
                      children: tabs.map((type) {
                        final vehicles = provider.filteredVehicles(type);
                        return RefreshIndicator(
                          onRefresh: () => _onRefresh(),
                          child: vehicles.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 200),
                                    Center(child: Text("No vehicles found")),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: vehicles.length,
                                  itemBuilder: (context, index) {
                                    final v = vehicles[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RentalVehicleDetailScreen(
                                                  vehicleId: v.id!,
                                                  isAvailable: v.isAvailable!,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withValues(
                                                alpha: 0.5,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(3, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Title + Availability
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        v.vehicleName ?? "",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        v.vehicleType ?? "",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          v.isAvailable == true
                                                          ? Colors.grey.shade500
                                                          : Colors
                                                                .grey
                                                                .shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      v.isAvailable == true
                                                          ? "Available"
                                                          : "Unavailable",
                                                      style: TextStyle(
                                                        color:
                                                            v.isAvailable ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: v.images.isNotEmpty
                                                  ? Image.network(
                                                      v.images.first,
                                                      height: 200,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      height: 200,
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                        Icons.directions_car,
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),

                                            // Info row
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.group,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${v.seatingCapacity ?? 0} seats",
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Icon(
                                                    Icons.work,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${v.bagCapacity ?? 0} bags",
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "₹${v.rentalPricePerHour ?? ''}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Text(
                                                        "per hour",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
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
                                    );
                                  },
                                ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
