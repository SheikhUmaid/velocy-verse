import 'package:flutter/material.dart';

class ComponentBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const ComponentBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _BottomNavItem(
          label: 'Book Ride',
          isSelected: selectedIndex == 0,
          onTap: () => onIndexChanged(0),
        ),
        _BottomNavItem(
          label: 'Rental',
          isSelected: selectedIndex == 1,
          onTap: () => onIndexChanged(1),
        ),
        _BottomNavItem(
          label: 'Ride Share',
          isSelected: selectedIndex == 2,
          onTap: () => onIndexChanged(2),
        ),
        _BottomNavItem(
          label: 'Corporate',
          isSelected: selectedIndex == 3,
          onTap: () => onIndexChanged(3),
        ),
      ],
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.black : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
