import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveDurationSelector extends StatefulWidget {
  final Function(String selectedDuration) onChanged;

  const LiveDurationSelector({super.key, required this.onChanged});

  @override
  State<LiveDurationSelector> createState() => _LiveDurationSelectorState();
}

class _LiveDurationSelectorState extends State<LiveDurationSelector> {
  String _selectedDuration = '3 Hours';

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFFEAB308)),
            const SizedBox(width: 6),
            Text(
              'Live Duration',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: textColorDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildOptionCard('1 Hour', 'Quick Question', buttonBlue),
            const SizedBox(width: 10),
            _buildOptionCard('3 Hours', 'Recommended', buttonBlue),
            const SizedBox(width: 10),
            _buildOptionCard('Custom', 'Lebih fleksibel', buttonBlue),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _selectedDuration == 'Custom'
              ? 'Dengan memilih opsi ini, live chat dapat diakhiri kapanpun kamu mau'
              : 'Dengan memilih opsi ini, live chat akan berakhir dengan sendirinya setelah $_selectedDuration.',
          style: GoogleFonts.manrope(
            fontSize: 11,
            color: const Color(0xFF64748B),
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(String title, String subtitle, Color activeColor) {
    bool isSelected = _selectedDuration == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedDuration = title);
          widget.onChanged(title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? activeColor : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? activeColor : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}