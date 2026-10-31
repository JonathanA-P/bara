import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/app_data_controller.dart';
import '../discussion/add_discussion_screen.dart';
import '../discussion/detail_post_screen.dart';
import '../profile/profile_screen.dart';
import 'models/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppDataController _dataController = AppDataController.instance;
  PostCategoryTab _selectedTab = PostCategoryTab.kuliah;
  late final PageController _tabPageController;

  List<PostModel> get _posts => _dataController.posts;

  final Set<String> _heartBurstPostIds = {};

  @override
  void initState() {
    super.initState();
    _tabPageController = PageController(initialPage: 0);
    _dataController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dataController.removeListener(_onDataChanged);
    _tabPageController.dispose();
    super.dispose();
  }

  void _switchTab(PostCategoryTab tab) {
    if (_selectedTab == tab) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedTab = tab);
    final pageIndex = tab == PostCategoryTab.kuliah ? 0 : 1;
    _tabPageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await _dataController.syncWithSupabase();
    if (mounted) setState(() {});
  }

  void _toggleLike(String postId) {
    HapticFeedback.lightImpact();
    _dataController.toggleLikePost(postId);
  }

  void _onDoubleTapPost(PostModel post) {
    HapticFeedback.mediumImpact();
    _dataController.setLikePost(post.id, true);
    setState(() {
      _heartBurstPostIds.add(post.id);
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          _heartBurstPostIds.remove(post.id);
        });
      }
    });
  }

  void _openCreatePostDialog() async {
    HapticFeedback.selectionClick();
    final newPost = await Navigator.push<PostModel>(
      context,
      CupertinoPageRoute(
        builder: (context) => AddDiscussionScreen(initialTab: _selectedTab),
      ),
    );

    if (newPost != null) {
      setState(() {
        _selectedTab = newPost.tab;
      });
      final targetPage = newPost.tab == PostCategoryTab.kuliah ? 0 : 1;
      if (_tabPageController.hasClients) {
        _tabPageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
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
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF5584C3),
                ),
                title: Text(
                  'Lihat Profil ${post.authorName}',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ProfileScreen(
                        peerName: post.authorName,
                        isStranger: true,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  post.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: const Color(0xFF5584C3),
                ),
                title: Text(
                  post.isBookmarked
                      ? 'Hapus dari Simpanan'
                      : 'Simpan Postingan',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  final saved = _dataController.toggleBookmarkPost(post.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        saved
                            ? 'Postingan disimpan ke Profil'
                            : 'Postingan dihapus dari simpanan',
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.report_problem_outlined,
                  color: Colors.redAccent,
                ),
                title: Text(
                  'Laporkan Postingan',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  await _dataController.submitIncidentReport(
                    accusedName: post.authorName,
                    category: 'Pelanggaran Diskusi',
                    description: post.title,
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Laporan dikirim ke moderator Hi!Gavi'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color headerBlue = Color(0xFF5A7FBA);
    const Color activeColor = Color(0xFF5A7FBA);

    return Scaffold(
      backgroundColor: headerBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Container(
                      height: 96,
                      width: double.infinity,
                      color: headerBlue,
                    ),

                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTabItem(
                                  label: 'Kuliah',
                                  isSelected:
                                      _selectedTab == PostCategoryTab.kuliah,
                                  onTap: () =>
                                      _switchTab(PostCategoryTab.kuliah),
                                ),
                              ),
                              Expanded(
                                child: _buildTabItem(
                                  label: 'Luar Kelas',
                                  isSelected:
                                      _selectedTab == PostCategoryTab.luarKelas,
                                  onTap: () =>
                                      _switchTab(PostCategoryTab.luarKelas),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.5,
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              alignment: _selectedTab == PostCategoryTab.kuliah
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: FractionallySizedBox(
                                widthFactor: 0.5,
                                child: Center(
                                  child: Container(
                                    height: 3.5,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      color: activeColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),

                Positioned(
                  top: 96 - 94 + 13,
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
                          errorBuilder: (context, error, stackTrace) =>
                              SvgPicture.asset(
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

            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: PageView(
                  controller: _tabPageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    final newTab = index == 0
                        ? PostCategoryTab.kuliah
                        : PostCategoryTab.luarKelas;
                    if (_selectedTab != newTab) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedTab = newTab);
                    }
                  },
                  children: [
                    _buildFeedList(PostCategoryTab.kuliah),
                    _buildFeedList(PostCategoryTab.luarKelas),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedList(PostCategoryTab tab) {
    final filteredPosts = _posts.where((p) => p.tab == tab).toList();

    return RefreshIndicator(
      color: const Color(0xFF5A7FBA),
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
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
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE2E8F0),
                    backgroundImage: AssetImage(_dataController.currentAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? activeColor : inactiveColor,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    final bool showHeartBurst = _heartBurstPostIds.contains(post.id);

    return GestureDetector(
      onDoubleTap: () => _onDoubleTapPost(post),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ProfileScreen(
                              peerName: post.authorName,
                              isStranger: true,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFFCBD5E1),
                        backgroundImage: AssetImage(post.authorAvatar),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ProfileScreen(
                                peerName: post.authorName,
                                isStranger: true,
                              ),
                            ),
                          );
                        },
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
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => _showPostOptions(post),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (post.badges.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: post.badges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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

                if (post.imageAttachment != null) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _navigateToDetail(post),
                    child: ClipRRect(
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
                          child: const Icon(
                            Icons.image_outlined,
                            color: Color(0xFF94A3B8),
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(post.id),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                                  scale: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.elasticOut,
                                  ),
                                  child: child,
                                ),
                            child: Icon(
                              post.isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey<bool>(post.isLiked),
                              size: 18,
                              color: post.isLiked
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${post.likesCount}',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: post.isLiked
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    GestureDetector(
                      onTap: () => _navigateToDetail(post),
                      behavior: HitTestBehavior.opaque,
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

                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _dataController.toggleBookmarkPost(post.id);
                      },
                      child: Icon(
                        post.isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 18,
                        color: post.isBookmarked
                            ? const Color(0xFF5A7FBA)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IgnorePointer(
            child: AnimatedScale(
              scale: showHeartBurst ? 1.15 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: AnimatedOpacity(
                opacity: showHeartBurst ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.28),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFEF4444),
                    size: 46,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(PostModel post) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DetailPostScreen(post: post),
      ),
    );
  }
}
