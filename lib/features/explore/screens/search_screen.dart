import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/core/services/discussion_service.dart';
import 'package:bara/features/auth/screens/discussion/detail_post_screen.dart';
import 'package:bara/features/auth/screens/home/models/post_model.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _PopularTopic {
  final String title;
  final int postCount;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _PopularTopic({
    required this.title,
    required this.postCount,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _discussions = [];
  bool _isLoading = false;
  String _selectedTag = 'Semua';

  final List<String> _bannerPills = ['#Matkul', '#Beasiswa', '#Organisasi'];

  final List<String> _recentSearches = [
    'Basis Data',
    'kuliah pemprograman',
    'Struktur Data',
  ];

  final List<_PopularTopic> _popularTopics = const [
    _PopularTopic(
      title: 'Algoritma & Pemrograman',
      postCount: 124,
      icon: Icons.trending_up_rounded,
      iconBg: Color(0xFFEFF6FF),
      iconColor: Color(0xFF3B82F6),
    ),
    _PopularTopic(
      title: 'Basis Data',
      postCount: 98,
      icon: Icons.storage_rounded,
      iconBg: Color(0xFFF5F3FF),
      iconColor: Color(0xFF7C3AED),
    ),
    _PopularTopic(
      title: 'Kehidupan Kampus',
      postCount: 76,
      icon: Icons.chat_bubble_outline_rounded,
      iconBg: Color(0xFFECFDF5),
      iconColor: Color(0xFF10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
    _loadDiscussions();
  }

  Future<void> _loadDiscussions() async {
    setState(() => _isLoading = true);
    try {
      final list = await DiscussionService().getDiscussions();
      if (mounted) {
        setState(() {
          _discussions = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[SearchScreen] Load error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDiscussions {
    final query = _searchController.text.trim().toLowerCase();
    return _discussions.where((d) {
      final title = (d['title'] as String? ?? '').toLowerCase();
      final content = (d['content'] as String? ?? '').toLowerCase();
      final tag = (d['tag'] as String? ?? '').toLowerCase();

      final matchesQuery = query.isEmpty ||
          title.contains(query) ||
          content.contains(query) ||
          tag.contains(query);

      final matchesTag = _selectedTag == 'Semua' ||
          tag.contains(_selectedTag.replaceAll('#', '').toLowerCase());

      return matchesQuery && matchesTag;
    }).toList();
  }

  void _onTagSelected(String tag) {
    setState(() {
      if (_selectedTag == tag) {
        _selectedTag = 'Semua';
      } else {
        _selectedTag = tag;
        _searchController.text = tag.replaceAll('#', '');
      }
    });
  }

  void _onTopicTapped(String topicName) {
    setState(() {
      _searchController.text = topicName;
      if (!_recentSearches.contains(topicName)) {
        _recentSearches.insert(0, topicName);
      }
    });
  }

  void _removeRecentSearch(String term) {
    setState(() {
      _recentSearches.remove(term);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);
    const Color subtitleColor = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryBlue,
          onRefresh: _loadDiscussions,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // TOP BANNER (FIGMA)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Eksplorasi Obrolan',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              'Temukan obrolan yang relevan untukmu.',
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            children: _bannerPills.map((pill) {
                              final isSelected = _selectedTag == pill;
                              return GestureDetector(
                                onTap: () => _onTagSelected(pill),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    pill,
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? primaryBlue : Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Image.asset(
                          'assets/images/CloudArt_margin.png',
                          width: 85,
                          height: 85,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // SEARCH TEXTFIELD (FIGMA)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.manrope(fontSize: 13, color: textColorDark),
                    decoration: InputDecoration(
                      hintText: 'Cari topik atau postingan...',
                      hintStyle: GoogleFonts.manrope(
                        color: const Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // RECENT SEARCHES (if active or query typed)
                if (_recentSearches.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentSearches.map((term) {
                      return GestureDetector(
                        onTap: () => _onTopicTapped(term),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                term,
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => _removeRecentSearch(term),
                                child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // TOPIK POPULER (FIGMA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Topik Populer',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColorDark,
                      ),
                    ),
                    Text(
                      'Lihat semua',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ...List.generate(_popularTopics.length, (index) {
                  final topic = _popularTopics[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _onTopicTapped(topic.title),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: topic.iconBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(topic.icon, color: topic.iconColor, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      topic.title,
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: textColorDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${topic.postCount} postingan',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: subtitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFFCBD5E1),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // UNTUK ANDA (FIGMA FEED)
                Text(
                  'Untuk Anda',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textColorDark,
                  ),
                ),
                const SizedBox(height: 10),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_filteredDiscussions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Tidak ada diskusi ditemukan.',
                        style: GoogleFonts.manrope(color: subtitleColor, fontSize: 12),
                      ),
                    ),
                  )
                else
                  ...List.generate(_filteredDiscussions.length, (index) {
                    final disc = _filteredDiscussions[index];
                    final profile = disc['profiles'] as Map<String, dynamic>?;
                    final authorName = profile?['full_name'] as String? ?? 'Alex Chen';
                    final major = profile?['major'] as String? ?? 'Computer Science • Year 3';
                    final title = disc['title'] as String? ?? '';
                    final content = disc['content'] as String? ?? '';
                    final tag = disc['tag'] as String? ?? 'Matkul';
                    final likes = disc['likes_count'] ?? 12;
                    final replies = disc['replies_count'] ?? 4;

                    return GestureDetector(
                      onTap: () {
                        final post = PostModel(
                          id: disc['id']?.toString() ?? '1',
                          authorName: authorName,
                          authorAvatar: 'assets/images/userLogo.png',
                          timeAgo: 'Terbaru',
                          userRole: major,
                          tab: PostCategoryTab.kuliah,
                          badges: [
                            PostBadge(
                              label: tag,
                              backgroundColor: const Color(0xFFE0F2FE),
                              textColor: const Color(0xFF0284C7),
                            ),
                          ],
                          title: title,
                          content: content,
                          likesCount: (likes as num).toInt(),
                          commentsCount: (replies as num).toInt(),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPostScreen(post: post),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
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
                                      Text(
                                        authorName,
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: textColorDark,
                                        ),
                                      ),
                                      Text(
                                        major,
                                        style: GoogleFonts.manrope(
                                          fontSize: 10,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8), size: 18),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#$tag',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: textColorDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: subtitleColor,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.favorite_border_rounded, size: 16, color: Color(0xFF94A3B8)),
                                const SizedBox(width: 4),
                                Text(
                                  '$likes',
                                  style: GoogleFonts.manrope(fontSize: 11, color: subtitleColor),
                                ),
                                const SizedBox(width: 14),
                                const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF94A3B8)),
                                const SizedBox(width: 4),
                                Text(
                                  '$replies',
                                  style: GoogleFonts.manrope(fontSize: 11, color: subtitleColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
