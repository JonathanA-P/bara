import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bara/features/auth/screens/home/main_screen.dart';
import 'package:bara/core/services/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String? fullName;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.fullName,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final token = _otpController.text.trim();
    if (token.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Masukkan 6 digit kode OTP yang dikirim ke email.',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().verifyOtp(
        email: widget.email,
        token: token,
        type: OtpType.signup,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Akun berhasil diverifikasi! Selamat datang di BARA.',
              style: GoogleFonts.manrope(fontSize: 12),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message.contains('Token has expired or is invalid')
                  ? 'Kode OTP salah atau telah kadaluarsa.'
                  : e.message,
              style: GoogleFonts.manrope(fontSize: 12),
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('[OTP] Error/fallback: $e');
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleResend() async {
    setState(() => _isResending = true);
    try {
      await AuthService().resendOtp(email: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kode OTP baru telah dikirim ke ${widget.email}',
              style: GoogleFonts.manrope(fontSize: 12),
            ),
            backgroundColor: const Color(0xFF5382C1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('[OTP Resend] Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textColorDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: buttonBlue,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verifikasi Kode OTP',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: textColorDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kami telah mengirim 6 digit kode verifikasi ke:',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: buttonBlue,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Kode OTP',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textColorDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    letterSpacing: 10,
                    fontWeight: FontWeight.w800,
                    color: textColorDark,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: '••••••',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Verifikasi Akun',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: _isResending ? null : _handleResend,
                  child: Text(
                    _isResending ? 'Mengirim ulang...' : 'Belum menerima kode? Kirim ulang',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: buttonBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

