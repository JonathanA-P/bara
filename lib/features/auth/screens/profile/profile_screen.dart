import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';

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
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isStranger = widget.isStranger ?? false;

    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              SizedBox(
                height: 180,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/CloudArt_margin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    if (!isStranger)
                      Positioned(
                        right: 0,
                        top: 140,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: buttonBlue, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                          ),
                          child: Text(
                            'Edit Profil',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: buttonBlue,
                            ),
                          ),
                        ),
                      ),

                    Positioned(
                      left: 12,
                      top: 80,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F8FF),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xFFCBD5E1),
                          backgroundImage:
                              AssetImage('assets/images/userLogo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aleca Cantika',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textColorDark,
                          ),
                        ),
                        Text(
                          '@aleciacentil_',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                    ),
                    child: Text(
                      'Follow',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded,
                          size: 20, color: Color(0xFF64748B)),
                      onPressed: () {},
                    ),
                  ),

                  if (!isStranger) ...[
                    const SizedBox(width: 4),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.settings_outlined,
                            size: 20, color: Color(0xFF64748B)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.article_outlined,
                      size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Text(
                    'Sistem Informasi',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Hai seperti sunshine, aku akan membantumu lebih melek bisnis. Yukk mutualan!',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF475569),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE2E8F0), thickness: 1),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('100+', 'Total Post'),
                  _buildStatItem('100+', 'Upvote'),
                  _buildStatItem('100+', 'Badge'),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: isStranger
                      ? [
                          _buildTabButton('Public Posts', 0),
                          _buildTabButton('Reposts', 2),
                        ]
                      : [
                          _buildTabButton('Public Posts', 0),
                          _buildTabButton('Private Posts', 1),
                          _buildTabButton('Reposts', 2),
                        ],
                ),
              ),

              const SizedBox(height: 16),

              if (!isStranger && _selectedTabIndex == 1) ...[
                Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Text(
                      'This post is private. Only you can see them',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              _buildPostCard(
                tag: 'STUDY NOTES',
                title: 'Complete Guide to Advanced Graph Algorithms',
                likes: '124',
                comments: '18',
                date: 'Oct 12',
              ),
              const SizedBox(height: 12),
              _buildPostCard(
                tag: 'PROJECT',
                title: 'React Native Mobile App Architecture Review',
                likes: '89',
                comments: '12',
                date: 'Oct 10',
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B))),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color:
                  isActive ? const Color(0xFF1E293B) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard({
    required String tag,
    required String title,
    required String likes,
    required String comments,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(tag,
                    style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2563EB))),
              ),
              const Icon(Icons.language, size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title,
              style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A))),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.favorite_border,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(likes,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF64748B))),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(comments,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF64748B))),
              const Spacer(),
              Text(date,
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: const Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}