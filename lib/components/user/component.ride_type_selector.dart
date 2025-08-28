import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/providers/user/provider.ride.dart';

class ComponentRideTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const ComponentRideTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Ride Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RideTypeCard(
                icon: Icons.schedule,
                label: 'Scheduled',
                isSelected: selectedType == 'Scheduled',
                onTap: () {
                  final rideProvider = Provider.of<RideProvider>(
                    context,
                    listen: false,
                  );
                  rideProvider.rideType = 'Scheduled'.toLowerCase();
                  onTypeChanged('scheduled');
                  context.pushNamed("/bookRide");
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RideTypeCard(
                icon: Icons.group,
                label: 'Pool',
                isSelected: selectedType == 'Pool',
                onTap: () => onTypeChanged('Pool'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RideTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RideTypeCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.black : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
