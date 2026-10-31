import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/app_data_controller.dart';
import '../../auth/screens/course/course_detail_screen.dart';
import '../../auth/screens/discussion/detail_post_screen.dart';
import '../../auth/screens/home/models/post_model.dart';
import '../../auth/screens/profile/profile_screen.dart';

typedef SearchItemData = Map<String, dynamic>;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final AppDataController _dataController = AppDataController.instance;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _showAllTopics = false;

  final List<SearchItemData> _historyItems = [
    {
      'title': 'Algoritma & Pemrograman',
      'code': 'IF2123',
      'subtitle': '284 post minggu ini',
      'type': 'course',
      'icon': Icons.show_chart,
      'isHistory': true,
    },
    {
      'title': 'Basis Data',
      'code': 'SI2204',
      'subtitle': '192 post minggu ini',
      'type': 'course',
      'icon': Icons.book_outlined,
      'isHistory': false,
    },
    {
      'title': 'Sistem Operasi',
      'code': 'IF2109',
      'subtitle': '156 post minggu ini',
      'type': 'course',
      'icon': Icons.memory_outlined,
      'isHistory': false,
    },
    {
      'title': 'Kecerdasan Buatan',
      'code': 'IF3102',
      'subtitle': '140 post minggu ini',
      'type': 'course',
      'icon': Icons.psychology_outlined,
      'isHistory': false,
    },
    {
      'title': 'Manajemen Sistem Informasi',
      'code': 'SI2101',
      'subtitle': '98 post minggu ini',
      'type': 'course',
      'icon': Icons.analytics_outlined,
      'isHistory': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _dataController.addListener(_onDataUpdated);
  }

  void _onDataUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dataController.removeListener(_onDataUpdated);
    _searchController.dispose();
    super.dispose();
  }

  void _openTopicItem(SearchItemData item) {
    HapticFeedback.selectionClick();
    final code = item['code'] as String? ?? 'IF2123';
    final course = _dataController.getCourseByCode(
      code,
      fallbackTitle: item['title'] as String?,
    );
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => CourseDetailScreen(
          code: course.code,
          title: course.title,
          category: 'MATA KULIAH ${course.badgeText.toUpperCase()}',
          sks: course.sks,
          semester: course.semester,
          rating: course.rating,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isSearching ? _buildSearchAppBar() : _buildHeaderBanner(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isSearching) ...[
                      const SizedBox(height: 4),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildTopTopicsSection(),
                      const SizedBox(height: 24),
                      _buildForYouSection(),
                    ] else ...[
                      _buildSearchContent(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF5A7FBA)),
      padding: const EdgeInsets.only(left: 20, top: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 64, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'HI! GAVI SIAP MENEMANIMU',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    height: 1.5,
                    letterSpacing: 1,
                    color: Color(0xFF273856),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 210,
                  child: Text(
                    'Temukan obrolan yang relevan untukmu.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 1.35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: Image.asset(
              'assets/images/bara_naik_pesawat.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.pets, size: 80, color: Colors.white54);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1E293B),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            },
          ),
          const Expanded(
            child: Text(
              'Cari',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        onTap: () {
          setState(() {
            _isSearching = true;
          });
        },
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Cari user, mata kuliah, atau postingan...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTopTopicsSection() {
    final visibleTopics =
        _showAllTopics ? _historyItems : _historyItems.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Topik populer',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _showAllTopics = !_showAllTopics;
                });
              },
              child: Text(
                _showAllTopics ? 'Sembunyikan' : 'Lihat semua',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3182CE),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...visibleTopics.map((item) => _buildItemTile(item)),
      ],
    );
  }

  Widget _buildForYouSection() {
    final featuredPosts = _dataController.posts.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Untuk Anda',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        ...featuredPosts.map(
          (post) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildForYouPostCard(post),
          ),
        ),
      ],
    );
  }

  Widget _buildForYouPostCard(PostModel post) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => DetailPostScreen(post: post),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                    radius: 20,
                    backgroundColor: const Color(0xFFCBD5E1),
                    backgroundImage: AssetImage(post.authorAvatar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.badges
                  .map(
                    (b) => _buildTagChip(
                      b.label,
                      isOrange: b.backgroundColor == const Color(0xFFF97316),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _dataController.toggleLikePost(post.id);
                  },
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: post.isLiked
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likesCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: post.isLiked
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  '${post.commentsCount}',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      final matchedUsers = _dataController.users
          .where(
            (u) =>
                u.name.toLowerCase().contains(query) ||
                u.username.toLowerCase().contains(query) ||
                u.major.toLowerCase().contains(query),
          )
          .toList();

      final matchedCourses = _dataController.courses
          .where(
            (c) =>
                c.title.toLowerCase().contains(query) ||
                c.code.toLowerCase().contains(query) ||
                c.prodi.toLowerCase().contains(query),
          )
          .toList();

      final matchedPosts = _dataController.posts
          .where(
            (p) =>
                p.title.toLowerCase().contains(query) ||
                p.content.toLowerCase().contains(query) ||
                p.authorName.toLowerCase().contains(query),
          )
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          if (matchedUsers.isEmpty &&
              matchedCourses.isEmpty &&
              matchedPosts.isEmpty)
            _buildEmptyHistoryState(
              customMessage: 'Tidak ada hasil untuk "$query"',
            )
          else ...[
            if (matchedUsers.isNotEmpty) ...[
              const Text(
                'Pengguna',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              ...matchedUsers.map(
                (u) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => ProfileScreen(
                            peerName: u.name,
                            isStranger: true,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(u.avatar),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  u.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  '${u.username} • ${u.major}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (matchedCourses.isNotEmpty) ...[
              const Text(
                'Mata Kuliah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              ...matchedCourses.map(
                (c) => _buildItemTile({
                  'title': '${c.code} - ${c.title.replaceAll('\n', ' ')}',
                  'code': c.code,
                  'subtitle': '${c.prodi} • Semester ${c.semester}',
                  'icon': Icons.menu_book_outlined,
                  'isHistory': false,
                }),
              ),
              const SizedBox(height: 14),
            ],
            if (matchedPosts.isNotEmpty) ...[
              const Text(
                'Diskusi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              ...matchedPosts.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildForYouPostCard(p),
                ),
              ),
            ],
          ],
        ],
      );
    }

    final bool isEmpty = _historyItems.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Histori',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            if (!isEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _historyItems.clear();
                  });
                },
                child: const Text(
                  'Hapus semua',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3182CE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (isEmpty)
          _buildEmptyHistoryState()
        else
          ..._historyItems.map((item) => _buildItemTile(item)),
      ],
    );
  }

  Widget _buildEmptyHistoryState({String? customMessage}) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/bara_tidur.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.nightlight_round,
                  size: 80,
                  color: Color(0xFF94A3B8),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              customMessage ?? 'Belum ada histori pencarian',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(SearchItemData item) {
    final bool isHistory = item['isHistory'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _openTopicItem(item),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF5A7FBA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item['icon'] ?? Icons.book_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isHistory ? Icons.close : Icons.chevron_right,
                  color: const Color(0xFF94A3B8),
                  size: 18,
                ),
                onPressed: () {
                  if (isHistory) {
                    setState(() {
                      _historyItems.remove(item);
                    });
                  } else {
                    _openTopicItem(item);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, {bool isOrange = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOrange ? const Color(0xFFFFEDD5) : const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOrange ? const Color(0xFFEA580C) : const Color(0xFF0369A1),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
