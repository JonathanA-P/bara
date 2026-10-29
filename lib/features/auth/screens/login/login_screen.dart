import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/features/auth/screens/home/main_screen.dart';
import 'package:bara/features/auth/screens/forgot_password/forgot_password_screen.dart';
import 'package:bara/features/auth/screens/register/register_ktm_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1B3A5C);
    const Color buttonBlue = Color(0xFF2D5F8A);
    const Color fieldBorder = Color(0xFFCBD5E1);
    const Color fieldBorderFocused = Color(0xFF5382C1);
    const Color textDark = Color(0xFF1E293B);
    const Color textMuted = Color(0xFF64748B);
    const Color bgColor = Color(0xFFF5F8FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),

                      // Title
                      Text(
                        'Welcome back, Alex',
                        style: GoogleFonts.manrope(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Continue your mentoring sessions, study rooms,\nand AI learning plan.',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: textMuted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Kampus label
                      Text(
                        'Email Kampus',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email field
                      _buildTextField(
                        controller: _emailController,
                        hintText: '',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: textMuted,
                          size: 20,
                        ),
                        borderColor: _emailController.text.isNotEmpty
                            ? fieldBorderFocused
                            : fieldBorder,
                      ),
                      const SizedBox(height: 20),

                      // Password label
                      Text(
                        'Password',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Password field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _passwordController.text.isNotEmpty
                                ? fieldBorderFocused
                                : fieldBorder,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: textMuted,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _isObscure,
                                onChanged: (_) => setState(() {}),
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              child: Icon(
                                _isObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: textMuted,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Remember me + Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: buttonBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: fieldBorder,
                                    width: 1.5,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ingat Saya',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Lupa Password?',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF5382C1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campus-grade privacy
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.verified_user_outlined,
                              color: const Color(0xFF4CAF50),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
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

                      // Spacer to push "Belum punya akun?" to the bottom
                      const Spacer(),

                      // Register link at bottom
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum punya akun? ',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: textMuted,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterKtmScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Daftar',
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Widget prefixIcon,
    Color borderColor = const Color(0xFFCBD5E1),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Row(
        children: [
          prefixIcon,
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (_) => setState(() {}),
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
        ],
      ),
    );
  }
}
