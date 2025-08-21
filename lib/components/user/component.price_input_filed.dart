import 'package:flutter/material.dart';

class PriceInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPriceSet;

  const PriceInputField({
    super.key,
    required this.controller,
    required this.onPriceSet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter price',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          // GestureDetector(
          //   onTap: onPriceSet,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     decoration: BoxDecoration(
          //       color: Colors.black,
          //       borderRadius: BorderRadius.circular(6),
          //     ),
          //     child: const Text(
          //       'Ok',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 14,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
