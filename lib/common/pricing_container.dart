import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PricingItem extends StatelessWidget {
  final String keys;
  final int value;
  final VoidCallback onDelete;

  PricingItem({
    required this.keys,
    required this.value,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$keys: $value',
            style: GoogleFonts.readexPro(
                fontSize: 19, fontWeight: FontWeight.w500),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}