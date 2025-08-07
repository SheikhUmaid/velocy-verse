// lib/components/booking/component.location_suggestions.dart
import 'package:flutter/material.dart';

class LocationSuggestion {
  final String name;
  final String address;

  LocationSuggestion({required this.name, required this.address});
}

class ComponentLocationSuggestions extends StatelessWidget {
  final List<LocationSuggestion> suggestions;
  final ValueChanged<LocationSuggestion> onSuggestionTap;

  const ComponentLocationSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return _SuggestionTile(
            suggestion: suggestion,
            onTap: () => onSuggestionTap(suggestion),
          );
        },
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final LocationSuggestion suggestion;
  final VoidCallback onTap;

  const _SuggestionTile({required this.suggestion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestion.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
