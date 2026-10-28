import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPostScreen extends StatefulWidget {
  const DetailPostScreen({super.key});

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
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
          'BARA',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: textColorDark,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: textColorDark, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: textColorDark, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- KONTEN POSTINGAN UTAMA & KOMENTAR (SCROLLABLE) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // KARTU POSTINGAN UTAMA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Header
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFCBD5E1),
                                backgroundImage: AssetImage('assets/images/CloudArt_margin.png'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Alex Chen',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '• 2h ago',
                                          style: GoogleFonts.manrope(
                                            fontSize: 10,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Computer Science • Year 3',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Tag Category
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ALGORITHM DESIGN',
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Title & Description
                          Text(
                            'How do you optimize BFS traversal for large graphs?',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'I\'m working on a social network analysis project and my current BFS implementation is timing out on graphs with 10M+ nodes. Are there any specific memory or data structure optimizations you\'d recommend?',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Attached Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/CloudArt_margin.png',
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Post Footer
                          Row(
                            children: [
                              const Icon(Icons.favorite_border, size: 16, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 4),
                              Text('124', style: GoogleFonts.manrope(fontSize: 11, color: const Color(0xFF64748B))),
                              const SizedBox(width: 16),
                              const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 4),
                              Text('32', style: GoogleFonts.manrope(fontSize: 11, color: const Color(0xFF64748B))),
                              const Spacer(),
                              const Icon(Icons.bookmark_border_rounded, size: 18, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 12),
                              const Icon(Icons.share_outlined, size: 18, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LIST KOMENTAR
                    _buildCommentCard(
                      name: 'Alex Chen',
                      timeAgo: '2h ago',
                      meta: 'Computer Science • Year 3',
                      content:
                          'I\'m working on a social network analysis project and my current BFS implementation is timing out on graphs with 10M+ nodes. Are there',
                      likes: '124',
                      comments: '32',
                    ),
                    const SizedBox(height: 12),
                    _buildCommentCard(
                      name: 'Alex Chen',
                      timeAgo: '2h ago',
                      meta: 'Computer Science • Year 3',
                      content:
                          'I\'m working on a social network analysis project and my current BFS implementation is timing out on graphs with 10M+ nodes. Are there',
                      likes: '124',
                      comments: '32',
                    ),
                    const SizedBox(height: 12),
                    _buildCommentCard(
                      name: 'Alex Chen',
                      timeAgo: '1h ago',
                      meta: 'Computer Science • Year 3',
                      content:
                          'I\'m working on a social network analysis project and my current BFS implementation is timing out on graphs with 10M+ nodes. Are there',
                      likes: '124',
                      comments: '32',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- BAR INPUT KOMENTAR DI BAWAH ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFCBD5E1),
                    backgroundImage: AssetImage('assets/images/CloudArt_margin.png'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Tulis sesuatu',
                          hintStyle: GoogleFonts.manrope(color: const Color(0xFF94A3B8), fontSize: 12),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _commentController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Post',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER KARTU KOMENTAR
  Widget _buildCommentCard({
    required String name,
    required String timeAgo,
    required String meta,
    required String content,
    required String likes,
    required String comments,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFCBD5E1),
                backgroundImage: AssetImage('assets/images/CloudArt_margin.png'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '• $timeAgo',
                          style: GoogleFonts.manrope(
                            fontSize: 9,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      meta,
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8), size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: const Color(0xFF475569),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(likes, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF64748B))),
              const SizedBox(width: 14),
              const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(comments, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFF64748B))),
              const Spacer(),
              const Icon(Icons.bookmark_border_rounded, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 10),
              const Icon(Icons.share_outlined, size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
        ],
      ),
    );
  }
}