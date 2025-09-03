// lib/components/booking/component.location_input.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/providers/user/provider.ride.dart';

class ComponentLocationInput extends StatelessWidget {
  ComponentLocationInput({super.key});
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropDownController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Pickup Location
          Row(
            children: [
              // Container(
              //   width: 12,
              //   height: 12,
              //   decoration: const BoxDecoration(
              //     color: Colors.black,
              //     shape: BoxShape.circle,
              //   ),
              // ),
              Icon(Icons.gps_fixed_rounded, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.pushNamed(
                      "/selectLocation",
                      extra: 0, // ->> zero means pickup location;
                    );
                  },
                  child: AbsorbPointer(
                    child: Consumer<RideProvider>(
                      builder: (_, provider, child) {
                        return TextFormField(
                          readOnly: true,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: provider.fromLocation?.address ?? '',
                              selection: TextSelection.collapsed(
                                offset: (provider.fromLocation?.address ?? '')
                                    .length,
                              ),
                            ),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pickup location',
                            hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          // const SizedBox(height: 2),

          // Connecting Line
          Row(
            children: [
              const SizedBox(width: 6),
              Container(
                width: 2,
                height: 40,
                color: const Color.fromARGB(255, 203, 203, 203),
              ),
              const SizedBox(width: 15),
            ],
          ),

          // const SizedBox(height: 16),

          // Drop Location
          Row(
            children: [
              // Container(
              //   width: 12,
              //   height: 12,
              //   decoration: const BoxDecoration(
              //     color: Colors.black,
              //     shape: BoxShape.circle,
              //   ),
              // ),
              Icon(Icons.location_pin, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.pushNamed(
                      "/selectLocation",
                      extra: 1, //---->>> 1 means
                    );
                  },
                  child: AbsorbPointer(
                    child: Consumer<RideProvider>(
                      builder: (_, provider, child) {
                        return TextFormField(
                          readOnly: true,

                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: provider.toLocation?.address ?? '',
                              selection: TextSelection.collapsed(
                                offset:
                                    (provider.toLocation?.address ?? '').length,
                              ),
                            ),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Drop location',
                            hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
