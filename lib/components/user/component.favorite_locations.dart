import 'package:flutter/material.dart';

class ComponentFavouriteLocations extends StatelessWidget {
  const ComponentFavouriteLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favourite',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _LocationCard(
              icon: Icons.home,
              label: 'Home',
              onTap: () => print('Home selected'),
            ),
            _LocationCard(
              icon: Icons.business,
              label: 'Office',
              onTap: () => print('Office selected'),
            ),
            _LocationCard(
              icon: Icons.business,
              label: 'Office',
              onTap: () => print('Office 2 selected'),
            ),
            _LocationCard(
              icon: Icons.flight,
              label: 'Airport',
              onTap: () => print('Airport selected'),
            ),
          ],
        ),
      ],
    );
  }
}

class _LocationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LocationCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
