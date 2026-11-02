import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_info_screen.dart';

/// Fase 5 - Registration form with name, email, NIM, program studi
class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  String? _selectedProdi;

  final List<String> _prodiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Mesin',
    'Ilmu Komputer',
    'Matematika',
    'Fisika',
    'Kimia',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1B3A5C);
    const Color buttonBlue = Color(0xFF2D5F8A);
    const Color fieldBorder = Color(0xFFCBD5E1);
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
                    border: Border.all(color: fieldBorder),
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

              // Nama Lengkap
              _buildLabel('Nama Lengkap'),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _nameController,
                hintText: 'Nama lengkap',
              ),
              const SizedBox(height: 18),

              // Email
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _emailController,
                hintText: 'Email kampus',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),

              // NIM
              _buildLabel('NIM'),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _nimController,
                hintText: 'Nomor Induk Mahasiswa',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),

              // Program Studi
              _buildLabel('Program Studi'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: fieldBorder, width: 1.5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedProdi,
                    isExpanded: true,
                    hint: Text(
                      'Pilih program studi',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: textMuted,
                    ),
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                    items: _prodiList.map((String prodi) {
                      return DropdownMenuItem<String>(
                        value: prodi,
                        child: Text(prodi),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedProdi = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Selanjutnya button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterInfoScreen(),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF334155),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: const Color(0xFFCBD5E1),
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
}

