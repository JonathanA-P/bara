import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../discussion/detail_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['For You', 'Live Chat', 'Following', 'Trending'];

  @override
  Widget build(BuildContext context) {
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFCBD5E1),
                    backgroundImage: AssetImage('assets/images/CloudArt_margin.png'),
                  ),
                  Text(
                    'BARA',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: textColorDark,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    children: [
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
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFFE2E8F0),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'What would you like to share today?',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Create',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    bool isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilterIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? buttonBlue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? buttonBlue : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            _filters[index],
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _navigateToDetail(context),
                child: _buildPostCard(
                  authorName: 'Alex Chen',
                  timeAgo: '2h ago',
                  userMeta: 'Computer Science • Year 3',
                  categoryTag: 'ALGORITHM DESIGN',
                  title: 'How do you optimize BFS traversal for large graphs?',
                  content:
                      'I am working on a social network analysis project and my current BFS implementation is timing out on graphs with 10M+ nodes. Are there...',
                  likes: '124',
                  comments: '32',
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => _navigateToDetail(context),
                child: _buildPostCardWithFile(
                  authorName: 'Elena Rostova',
                  timeAgo: '5h ago',
                  userMeta: 'Top Mentor • 12k Contributions',
                  title: 'Graph Traversal Cheat Sheet',
                  fileName: 'Traversal_Algorithms_v2.pdf',
                  fileSize: '2.4 MB • 4 PAGES',
                  likes: '342',
                  comments: '89',
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => _navigateToDetail(context),
                child: _buildPostCardWithImage(
                  authorName: 'Alex Chen',
                  timeAgo: '2h ago',
                  userMeta: 'Computer Science • Year 3',
                  categoryTag: 'ALGORITHM DESIGN',
                  title: 'How do you optimize BFS traversal for large graphs?',
                  content:
                      'I am working on a social network analysis project and my current BFS implementation is timing out...',
                  imagePath: 'assets/images/CloudArt_margin.png',
                  likes: '124',
                  comments: '32',
                ),
              ),

              const SizedBox(height: 120), 
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailPostScreen(),
      ),
    );
  }

  Widget _buildPostCard({
    required String authorName,
    required String timeAgo,
    required String userMeta,
    required String categoryTag,
    required String title,
    required String content,
    required String likes,
    required String comments,
  }) {
    return Container(
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
          _buildUserHeader(authorName, timeAgo, userMeta),
          const SizedBox(height: 12),
          _buildCategoryBadge(categoryTag),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _buildPostFooter(likes, comments),
        ],
      ),
    );
  }

  Widget _buildPostCardWithFile({
    required String authorName,
    required String timeAgo,
    required String userMeta,
    required String title,
    required String fileName,
    required String fileSize,
    required String likes,
    required String comments,
  }) {
    return Container(
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
          _buildUserHeader(authorName, timeAgo, userMeta),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        fileSize,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.download_rounded, color: Color(0xFF64748B), size: 20),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildPostFooter(likes, comments),
        ],
      ),
    );
  }

  Widget _buildPostCardWithImage({
    required String authorName,
    required String timeAgo,
    required String userMeta,
    required String categoryTag,
    required String title,
    required String content,
    required String imagePath,
    required String likes,
    required String comments,
  }) {
    return Container(
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
          _buildUserHeader(authorName, timeAgo, userMeta),
          const SizedBox(height: 12),
          _buildCategoryBadge(categoryTag),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          _buildPostFooter(likes, comments),
        ],
      ),
    );
  }

  Widget _buildUserHeader(String name, String time, String meta) {
    return Row(
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
                    name,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '• $time',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Text(
                meta,
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
    );
  }

  Widget _buildCategoryBadge(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: GoogleFonts.manrope(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF2563EB),
        ),
      ),
    );
  }

  Widget _buildPostFooter(String likes, String comments) {
    return Row(
      children: [
        const Icon(Icons.favorite_border, size: 16, color: Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(likes, style: GoogleFonts.manrope(fontSize: 11, color: const Color(0xFF64748B))),
        const SizedBox(width: 16),
        const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(comments, style: GoogleFonts.manrope(fontSize: 11, color: const Color(0xFF64748B))),
        const Spacer(),
        const Icon(Icons.bookmark_border_rounded, size: 18, color: Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        const Icon(Icons.share_outlined, size: 18, color: Color(0xFF94A3B8)),
      ],
    );
  }
}