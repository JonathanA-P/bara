import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool? isStranger;

  const ProfileScreen({
    super.key,
    this.isStranger = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profil state
  String _name = 'Aleca Cantika';
  String _username = '@aleciacentil_';
  String _major = 'Sistem Informasi';
  String _bio =
      'Hai seperti sunshine, aku akan membantumu lebih melek bisnis. Yukk mutualan!';

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Red Logout Icon inside light red box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFDC2626),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Keluar?',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  'Yakin untuk melanjutkan? Kamu akan keluar dari akun.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Batal
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Keluar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Keluar',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openEditProfile() async {
    final updated = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: _name,
          initialUsername: _username.replaceFirst('@', ''),
          initialMajor: _major,
          initialBio: _bio,
        ),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _name = updated['name'] ?? _name;
        _username = '@${updated['username'] ?? _username}';
        _major = updated['major'] ?? _major;
        _bio = updated['bio'] ?? _bio;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. HEADER BANNER & OVERLAPPING AVATAR
              SizedBox(
                height: 180,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Landscape Banner
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/CloudArt_margin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Edit Profil and Logout Buttons
                    Positioned(
                      right: 0,
                      top: 150,
                      child: Row(
                        children: [
                          // Edit Profil Button
                          OutlinedButton(
                            onPressed: _openEditProfile,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFCBD5E1),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Edit Profil',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: textColorDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Logout Icon Button
                          GestureDetector(
                            onTap: _showLogoutDialog,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFCBD5E1),
                                  width: 1.2,
                                ),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFDC2626),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Avatar Overlapping Banner
                    Positioned(
                      left: 14,
                      top: 88,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFCBD5E1),
                          backgroundImage:
                              AssetImage('assets/images/userLogo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. NAME & USERNAME
              Text(
                _name,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textColorDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _username,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 14),

              // 3. STATS ROW (100+ Total Post, 100+ Followers, 100+ Following)
              Row(
                children: [
                  _buildStatItem('100+', 'Total Post'),
                  const SizedBox(width: 24),
                  _buildStatItem('100+', 'Followers'),
                  const SizedBox(width: 24),
                  _buildStatItem('100+', 'Following'),
                ],
              ),

              const SizedBox(height: 14),

              // 4. MAJOR (Program Studi)
              Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _major,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // 5. BIO
              Text(
                _bio,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF475569),
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 18),
              const Divider(color: Color(0xFFE2E8F0), thickness: 1),
              const SizedBox(height: 8),

              // 6. FEED OF USER POSTS (As shown in Figma)
              // Post 1
              _buildFigmaPostCard(
                authorName: 'Alex Chen',
                timeAgo: '2j lalu',
                role: 'Computer Science • Year 3',
                avatarAsset: 'assets/images/userLogo.png',
                badges: const [
                  {'label': 'SISTEM INFOR...', 'color': Color(0xFFF97316)},
                  {'label': 'PROBABILITAS ...', 'color': Color(0xFFE0F2FE), 'textColor': Color(0xFF0284C7)},
                ],
                title:
                    'Besok aku UTS, ada yang punya materi atau catetan gaa? Dosenku AFK : (',
                content:
                    'Aku baru masuk materi modul 1, tapi kaya ini susah banget gilak!!! Kalau ada yang mau belajar barng sokk kita ke CW',
                likes: '124',
                comments: '32',
              ),

              const SizedBox(height: 14),

              // Post 2
              _buildFigmaPostCard(
                authorName: 'Elena Rostova',
                timeAgo: '5j lalu',
                role: 'Top Mentor • 14k Contrib',
                avatarAsset: 'assets/images/userLogo.png',
                badges: const [
                  {'label': 'TEKNOLOGI INF...', 'color': Color(0xFF22C55E)},
                  {'label': 'PEMROGRAMAN ..', 'color': Color(0xFFE0F2FE), 'textColor': Color(0xFF0284C7)},
                ],
                title: 'Materi Pemdas',
                content: '',
                likes: '89',
                comments: '14',
              ),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFigmaPostCard({
    required String authorName,
    required String timeAgo,
    required String role,
    required String avatarAsset,
    required List<Map<String, dynamic>> badges,
    required String title,
    required String content,
    required String likes,
    required String comments,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header Row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(avatarAsset),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: authorName,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          TextSpan(
                            text: ' • $timeAgo',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      role,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
            ],
          ),

          const SizedBox(height: 10),

          // Badges
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: badges.map((b) {
              final Color bg = b['color'] as Color;
              final Color textCol = (b['textColor'] as Color?) ?? Colors.white;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  b['label'] as String,
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: textCol,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
              height: 1.35,
            ),
          ),

          if (content.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              content,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Bottom like / comment stats
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                likes,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline_rounded,
                  size: 15, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                comments,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1),
        ],
      ),
    );
  }
}
