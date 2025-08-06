import 'package:flutter/material.dart';

class ComponentSearchBar extends StatelessWidget {
  const ComponentSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 22, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Where to?',
                style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
              ),
            ),
            const Icon(Icons.mic_outlined, size: 22, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
