import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_form_screen.dart';
import '../login/login_screen.dart';

/// Fase 6 - KTM Upload/Scan screen
class RegisterKtmScreen extends StatefulWidget {
  const RegisterKtmScreen({super.key});

  @override
  State<RegisterKtmScreen> createState() => _RegisterKtmScreenState();
}

class _RegisterKtmScreenState extends State<RegisterKtmScreen> {
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1B3A5C);
    const Color buttonBlue = Color(0xFF2D5F8A);
    const Color textDark = Color(0xFF1E293B);
    const Color textMuted = Color(0xFF64748B);
    const Color bgColor = Color(0xFFF5F8FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Step indicator
              _buildStepIndicator(1, 2),
              const SizedBox(height: 24),

              // Title
              Text(
                'Buat Akun HiGavi',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Daftar pakai email kampusmu.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Upload photo instruction
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: primaryBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unggah Foto Profil',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      Text(
                        'maks 5MB (opsional)',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // KTM Preview card
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                  image: _selectedImagePath != null
                      ? DecorationImage(
                          image: AssetImage(_selectedImagePath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImagePath == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.credit_card,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Preview KTM',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),

              // Info text
              Text(
                'Scan KT untuk dapat 1-4 "Karma untuk melakukan pendaftaran',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Scan KTM button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Open camera/file picker for KTM
                    _showKtmSourcePicker(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDBEAFE),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Scan KTM',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campus-grade privacy
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: const Color(0xFF4CAF50),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: textMuted,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Campus-grade privacy. ',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                            text:
                                'HiGavi verifies your student identity and keeps your academic data encrypted.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Selanjutnya button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterFormScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Selanjutnya',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Already have account
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5382C1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int current, int total) {
    return Row(
      children: [
        Text(
          'Langkah $current dari $total',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5382C1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: List.generate(total, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < total - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: index < current
                        ? const Color(0xFF5382C1)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showKtmSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pilih sumber KTM',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _sourceButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Kamera',
                        onTap: () {
                          Navigator.pop(context);
                          // Camera logic
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sourceButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Galeri',
                        onTap: () {
                          Navigator.pop(context);
                          // Gallery logic
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sourceButton(
                        icon: Icons.insert_drive_file_outlined,
                        label: 'File',
                        onTap: () {
                          Navigator.pop(context);
                          // File picker logic
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: const Color(0xFF5382C1)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

