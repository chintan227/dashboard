import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class PrimaryButton extends StatefulWidget {
  String text;
  Function()? onTap;
  PrimaryButton({super.key, required this.text, required this.onTap});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: darkGradient,
        ),
        padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
        child: Text(
          widget.text,
          style: GoogleFonts.readexPro(color: Colors.white),
        ),
      ),
    );
  }
}
