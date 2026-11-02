import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaraText extends StatelessWidget {
  final double opacity;
  final Color color;
  final double fontSize;

  const BaraText({
    super.key,
    required this.opacity,
    this.color = Colors.white,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Text(
        'H i G a v i',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          fontSize: fontSize,
          letterSpacing: 12,
          color: color,
        ),
      ),
    );
  }
}