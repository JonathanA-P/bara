import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/post_model.dart';
import '../discussion/detail_post_screen.dart';
import '../discussion/add_discussion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostCategoryTab _selectedTab = PostCategoryTab.kuliah;

  // Dynamic posts state
  late List<PostModel> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _getInitialPosts();
  }

  List<PostModel> _getInitialPosts() {
    return [
      // KULIAH POST 1
      PostModel(
        id: 'kuliah_1',
        authorName: 'Alex Chen',
        authorAvatar: 'assets/images/userLogo.png',
        timeAgo: '2j lalu',
        userRole: 'Sistem Informasi • Angkatan 2023',
        tab: PostCategoryTab.kuliah,
        badges: const [
          PostBadge(
            label: 'SISTEM INFOR...',
            backgroundColor: Color(0xFFF97316),
            textColor: Colors.white,
          ),
          PostBadge(
            label: 'PROBABILITAS ...',
            backgroundColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0284C7),
          ),
        ],
        title: 'Besok aku UTS, ada yang punya materi atau catetan gaa? Dosenku AFK : (',
        content:
            'Aku baru masuk materi modul 1, tapi kaya ini susah banget gilak!!! Kalau ada yang mau belajar barng sokk kita ke CW',
        likesCount: 124,
        commentsCount: 32,
      ),

      // KULIAH POST 2 (With image attachment)
      PostModel(
        id: 'kuliah_2',
        authorName: 'Alex Chen',
        authorAvatar: 'assets/images/userLogo.png',
        timeAgo: '2j lalu',
        userRole: 'Teknik Komputer • Angkatan 2022',
        tab: PostCategoryTab.kuliah,
        badges: const [
          PostBadge(
            label: 'TEKNIK KOMPUTER',
            backgroundColor: Color(0xFFEAB308),
            textColor: Colors.white,
          ),
          PostBadge(
            label: 'ALGORITHM DESIGN',
            backgroundColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0284C7),
          ),
        ],
        title: 'How do you optimize BFS traversal for large graphs?',
        content: 'I\'m working on a social network ......',
        imageAttachment: 'assets/images/CloudArt_margin.png',
        likesCount: 124,
        commentsCount: 32,
      ),

      // LUAR KELAS POST 1
      PostModel(
        id: 'luar_1',
        authorName: 'Alex Chen',
        authorAvatar: 'assets/images/userLogo.png',
        timeAgo: '2j lalu',
        userRole: 'HiGavi Community Enthusiast',
        tab: PostCategoryTab.luarKelas,
        badges: const [
          PostBadge(
            label: 'AMHIGAVIWA MEME',
            backgroundColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0284C7),
          ),
        ],
        title: 'Besok aku UTS, ada yang punya materi atau catetan gaa? Dosenku AFK : (',
        content:
            'Aku baru masuk materi modul 1, tapi kaya ini susah banget gilak!!! Kalau ada yang mau belajar barng sokk kita ke CW',
        likesCount: 124,
        commentsCount: 32,
      ),

      // LUAR KELAS POST 2
      PostModel(
        id: 'luar_2',
        authorName: 'Alex Chen',
        authorAvatar: 'assets/images/userLogo.png',
        timeAgo: '2j lalu',
        userRole: 'Campus Storyteller',
        tab: PostCategoryTab.luarKelas,
        badges: const [
          PostBadge(
            label: 'HOROR SERIES',
            backgroundColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0284C7),
          ),
        ],
        title: 'Besok aku UTS, ada yang punya materi atau catetan gaa? Dosenku AFK : (',
        content:
            'Aku baru masuk materi modul 1, tapi kaya ini susah banget gilak!!! Kalau ada yang mau belajar barng sokk kita ke CW',
        likesCount: 124,
        commentsCount: 32,
      ),
    ];
  }

  void _toggleLike(String postId) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final newIsLiked = !post.isLiked;
        final newLikes = newIsLiked ? post.likesCount + 1 : post.likesCount - 1;
        _posts[index] = post.copyWith(
          isLiked: newIsLiked,
          likesCount: newLikes < 0 ? 0 : newLikes,
        );
      }
    });
  }

  void _openCreatePostDialog() async {
    final newPost = await Navigator.push<PostModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddDiscussionScreen(
          initialTab: _selectedTab,
        ),
      ),
    );

    if (newPost != null) {
      setState(() {
        _posts.insert(0, newPost);
        _selectedTab = newPost.tab;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Postingan berhasil ditambahkan!'),
            backgroundColor: Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showPostOptions(PostModel post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Color(0xFF5584C3)),
                title: Text('Bagikan Tautan Diskusi', style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_outline_rounded, color: Color(0xFF5584C3)),
                title: Text('Simpan Postingan', style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
                title: Text('Laporkan Postingan', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: Colors.redAccent)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _posts.where((p) => p.tab == _selectedTab).toList();
    const Color headerBlue = Color(0xFF5A7FBA);

    return Scaffold(
      backgroundColor: headerBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- HEADER & TABS WITH MASCOT OVERLAY ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Layer 1: Blue Header Background + White Tab Bar
                Column(
                  children: [
                    // Blue Header Area
                    Container(
                      height: 96,
                      width: double.infinity,
                      color: headerBlue,
                    ),

                    // White Tabs Bar
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTabItem(
                              label: 'Kuliah',
                              isSelected: _selectedTab == PostCategoryTab.kuliah,
                              onTap: () => setState(() => _selectedTab = PostCategoryTab.kuliah),
                            ),
                          ),
                          Expanded(
                            child: _buildTabItem(
                              label: 'Luar Kelas',
                              isSelected: _selectedTab == PostCategoryTab.luarKelas,
                              onTap: () => setState(() => _selectedTab = PostCategoryTab.luarKelas),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Layer 2: Mascot + HiGavi Text (Paws overlapping the border line)
                Positioned(
                  top: 96 - 94 + 13, // Mascot paws hang 13px down over the dividing line
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/hiGavi.png',
                          height: 94,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                            'assets/images/hiGavi.svg',
                            height: 94,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Text(
                            'HiGavi',
                            style: GoogleFonts.manrope(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFF8FAFC),
                              letterSpacing: 0.5,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- SCROLLABLE FEED CONTENT ---
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                  children: [
                    // --- PROMPT SEARCH / CREATE POST BAR ---
                    GestureDetector(
                      onTap: _openCreatePostDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFFE2E8F0),
                              backgroundImage: AssetImage('assets/images/userLogo.png'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Apa yang sedang kamu bingungkan?',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // --- DYNAMIC POSTS LIST ---
                    if (filteredPosts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'Belum ada diskusi di kategori ini.\nJadilah yang pertama bertanya!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: const Color(0xFF94A3B8),
                              height: 1.5,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredPosts.map((post) => _buildPostCard(post)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFF5A7FBA);
    const inactiveColor = Color(0xFF94A3B8);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 3.5,
              width: 72,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFCBD5E1),
                backgroundImage: AssetImage(post.authorAvatar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      post.authorName,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${post.timeAgo}',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
                onPressed: () => _showPostOptions(post),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Dynamic Category Badges
          if (post.badges.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.badges.map((badge) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badge.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge.label,
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: badge.textColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 8),

          // Post Title (Clickable to detail)
          GestureDetector(
            onTap: () => _navigateToDetail(post),
            child: Text(
              post.title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Post Description Content
          GestureDetector(
            onTap: () => _navigateToDetail(post),
            child: Text(
              post.content,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
          ),

          // Attached Image (if any)
          if (post.imageAttachment != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                post.imageAttachment!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: const Color(0xFFF1F5F9),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, color: Color(0xFF94A3B8), size: 36),
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Interactions Footer: Likes & Comments
          Row(
            children: [
              // Like button
              GestureDetector(
                onTap: () => _toggleLike(post.id),
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 18,
                      color: post.isLiked ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post.likesCount}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: post.isLiked ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Comment button
              GestureDetector(
                onTap: () => _navigateToDetail(post),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 17,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${post.commentsCount}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailPostScreen(),
      ),
    );
  }
}
