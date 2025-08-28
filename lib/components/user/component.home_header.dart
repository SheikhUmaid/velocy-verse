import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/providers/user/provider.rider_profile.dart';

class ComponentHomeHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String subGreeting;

  const ComponentHomeHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.subGreeting,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Consumer<RiderProfileProvider>(
                builder: (_, prov, __) {
                  // prov.getRiderProfile();
                  return Image.network(
                    prov.profileURL ?? "", // Replace with actual asset
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subGreeting,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 22,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
