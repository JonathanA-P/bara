import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaraText extends StatelessWidget {
  final double opacity;
  final Color color;
  final double fontSize;

  const BaraText({
    super.key,
    required this.opacity,
    this.color = const Color(0xFFE2E8F0),
    this.fontSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Text(
        'HiGavi',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          letterSpacing: 3.5,
          color: color,
        ),
      ),
    );
  }
}
