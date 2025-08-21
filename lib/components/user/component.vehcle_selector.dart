import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/utils/responsive_wraper.dart';

class VehicleSelector extends StatelessWidget {
  final String selectedVehicle;
  final ValueChanged<String> onVehicleSelected;

  const VehicleSelector({
    super.key,
    required this.selectedVehicle,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    return ResponsiveWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VehicleOption(
            type: 'bike',
            icon: 'http://82.25.104.152/media/vehicle_types/bike.png',
            isSelected: selectedVehicle == 'bike',
            onTap: () async {
              await rideProvider.getEstimatedPrice(vehicleId: 2);
              onVehicleSelected('bike');
            },
          ),
          VehicleOption(
            type: 'auto',
            icon: 'http://82.25.104.152/media/vehicle_types/auto.png',
            isSelected: selectedVehicle == 'auto',
            onTap: () async {
              await rideProvider.getEstimatedPrice(vehicleId: 4);
              onVehicleSelected('auto');
            },
          ),
          VehicleOption(
            type: 'car',
            icon: 'http://82.25.104.152/media/vehicle_types/car_DsJ2mjy.png',
            isSelected: selectedVehicle == 'car',
            onTap: () async {
              await rideProvider.getEstimatedPrice(vehicleId: 9);
              onVehicleSelected('car');
            },
          ),
        ],
      ),
    );
  }
}

class VehicleOption extends StatelessWidget {
  final String type;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleOption({
    super.key,
    required this.type,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Image.network(icon)),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
