import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Aleca Cantika');
  final TextEditingController _usernameController =
      TextEditingController(text: '@aleda');
  final TextEditingController _taglineController =
      TextEditingController(text: 'Sistem Informasi');
  final TextEditingController _bioController =
      TextEditingController(text: 'apa?');

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _taglineController.dispose();
    _bioController.dispose();
    super.dispose();
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
        title: Text(
          'Edit Profil',
          style: GoogleFonts.manrope(
            color: textColorDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [

                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/CloudArt_margin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/pencil.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 75,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F8FF),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage('assets/images/userLogo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: buttonBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit Foto Profil',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.link, size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              _buildInputField('Nama Panjang', _nameController),
              const SizedBox(height: 16),
              _buildInputField('Username', _usernameController),
              const SizedBox(height: 16),
              _buildInputField('Tagline', _taglineController),
              const SizedBox(height: 16),
              _buildInputField('Bio', _bioController, maxLines: 2),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/centang.svg',
                width: 18,
                height: 18,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF22C55E),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}