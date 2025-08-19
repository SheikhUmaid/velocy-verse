import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String countryCode;
  final VoidCallback? onTenDigits; // ✅ added callback

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.label,
    this.countryCode = '+91',
    this.onTenDigits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryCode,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  // const SizedBox(width: 4),
                  // const Icon(
                  //   Icons.keyboard_arrow_down,
                  //   size: 20,
                  //   color: Color(0xFF6B7280),
                  // ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                maxLength: 10, // ✅ optional: prevent > 10 digits
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  counterText: "", // ✅ hide counter text
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black),
                onChanged: (value) {
                  if (value.length == 10) {
                    onTenDigits?.call(); // 🔔 trigger callback
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
