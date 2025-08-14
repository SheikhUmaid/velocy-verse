import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class RentalVehicleOwnerInfoScreen extends StatefulWidget {
  final int vehicleId;
  const RentalVehicleOwnerInfoScreen({super.key, required this.vehicleId});

  @override
  State<RentalVehicleOwnerInfoScreen> createState() =>
      _RentalVehicleOwnerInfoScreenState();
}

class _RentalVehicleOwnerInfoScreenState
    extends State<RentalVehicleOwnerInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RentalProvider>(
        context,
        listen: false,
      ).fetchRentalVehicleOwnerInfo(widget.vehicleId);
    });
  }

  void openImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(foregroundColor: Colors.white),
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(child: Image.network(imageUrl)),
            ),
          ),
        ),
      ),
    );
  }

  void openImageCaurosel(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          final pageController = PageController(initialPage: initialIndex);
          int currentIndex = initialIndex;

          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  centerTitle: false,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  title: Text(
                    '${currentIndex + 1} / ${images.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                body: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) => setState(() {
                    currentIndex = index;
                  }),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: InteractiveViewer(
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RentalProvider>(context);
    final info = provider.rentalVehicleOwnerIfo;

    return Scaffold(
      appBar: AppBar(title: const Text("Rental Vehicle Owner Profile")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : info == null
          ? const Center(child: Text("No data found"))
          : ListView(
              children: [
                // Owner Info Row
                Divider(color: Colors.grey.shade100, thickness: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => openImage(
                          "http://82.25.104.152/${info.user!.profile!}",
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: info.user?.profile != null
                              ? NetworkImage(
                                  "http://82.25.104.152/${info.user!.profile!}",
                                )
                              : null,
                          child: info.user?.profile == null
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.user?.username ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${info.registrationNumber ?? ''}\n${info.vehicleName ?? ''} - ${info.vehicleColor ?? ''}",
                              style: const TextStyle(color: Colors.grey),
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
                              icon: const Icon(Icons.phone_rounded),
                              onPressed: () {
                                if (info.user?.phoneNumber != null) {
                                  launchUrl(
                                    Uri.parse("tel:${info.user!.phoneNumber!}"),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.sms_rounded),
                              onPressed: () {
                                if (info.user?.phoneNumber != null) {
                                  launchUrl(
                                    Uri.parse("sms:${info.user!.phoneNumber!}"),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade100, thickness: 10),

                // Price
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Price", style: TextStyle(color: Colors.grey[700])),
                      Text(
                        "₹${info.rentalPricePerHour ?? '0'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade100, thickness: 10),
                // Vehicle Photos
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Vehicle Photos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: info.images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => openImageCaurosel(
                                info.images
                                    .map((img) => "http://82.25.104.152/$img")
                                    .toList(),
                                index,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "http://82.25.104.152/${info.images[index]}",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade100, thickness: 10),

                // Aadhar Card
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Owner Aadhar Card",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () => openImage(
                              "http://82.25.104.152/${info.user!.aadharCard!}",
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "View Aadhar",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (info.user?.aadharCard != null)
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => openImage(
                              "http://82.25.104.152/${info.user!.aadharCard!}",
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "http://82.25.104.152/${info.user!.aadharCard!}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade100, thickness: 10),

                // Vehicle Papers
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Vehicle Papers",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () => openImage(
                              "http://82.25.104.152/${info.vehiclePapersDocument!}",
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "View Papers",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (info.vehiclePapersDocument != null)
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => openImage(
                              "http://82.25.104.152/${info.vehiclePapersDocument!}",
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "http://82.25.104.152/${info.vehiclePapersDocument!}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: const Text(
                    "Free cancellation up to 24 hours before pickup",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
    );
  }
}
