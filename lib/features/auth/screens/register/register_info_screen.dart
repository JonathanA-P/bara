import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/app_data_controller.dart';
import '../../../../core/services/auth_service.dart';
import 'email_verification_screen.dart';

/// Fase 4 - Account info (username, email, password, confirm password)
class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({super.key});

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final ctrl = AppDataController.instance;
    if (ctrl.pendingRegEmail.isNotEmpty) {
      _emailController.text = ctrl.pendingRegEmail;
    }
    if (ctrl.pendingRegName.isNotEmpty) {
      _usernameController.text = ctrl.pendingRegName
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]'), '');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap isi semua kolom pendaftaran.',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password minimal 8 karakter.',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Konfirmasi password tidak cocok.',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap setujui Syarat & Ketentuan serta Kebijakan Privasi Hi!Gavi.',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final ctrl = AppDataController.instance;
    final fullName =
        ctrl.pendingRegName.isNotEmpty ? ctrl.pendingRegName : username;
    final nim =
        ctrl.pendingRegNim.isNotEmpty ? ctrl.pendingRegNim : '235150200111001';
    final major = ctrl.pendingRegProdi;

    try {
      await AuthService().signUp(
        email: email,
        password: password,
        fullName: fullName,
        nim: nim,
        major: major,
      );
    } catch (_) {}

    await ctrl.registerNewAccount(
      fullName: fullName,
      username: username,
      email: email,
      nim: nim,
      major: major,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EmailVerificationScreen(
            email: email,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildStepIndicator(2, 2),
              const SizedBox(height: 24),

              // Title
              Text(
                'Informasi Akun',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'Lengkapi informasimu.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Username
              _buildLabel('Username'),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _usernameController,
                hintText: 'Pilih username',
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

              // Password
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _passwordController,
                hintText: 'Minimal 8 karakter',
                isObscure: _isObscurePassword,
                onToggle: () {
                  setState(() {
                    _isObscurePassword = !_isObscurePassword;
                  });
                },
              ),
              const SizedBox(height: 18),

              // Confirm Password
              _buildLabel('Konfirmasi Password'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Ulangi password',
                isObscure: _isObscureConfirm,
                onToggle: () {
                  setState(() {
                    _isObscureConfirm = !_isObscureConfirm;
                  });
                },
              ),
              const SizedBox(height: 18),

              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _agreedToTerms,
                      activeColor: buttonBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(
                        color: fieldBorder,
                        width: 1.5,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _agreedToTerms = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: textMuted,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                'Saya menyetujui Ketentuan Layanan & Kebijakan Privasi Hi!Gavi',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Daftar Sekarang button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Daftar Sekarang',
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isObscure,
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
          ),
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              isObscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF64748B),
              size: 20,
            ),
          ),
        ],
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
