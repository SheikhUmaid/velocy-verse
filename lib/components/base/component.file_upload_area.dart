// lib/components/profile/component.file_upload_area.dart
import 'package:flutter/material.dart';

class ComponentFileUploadArea extends StatelessWidget {
  const ComponentFileUploadArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.file_upload_outlined,
              size: 24,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload Adhar Card document',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'PDF, JPG or PNG (max. 5MB)',
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
