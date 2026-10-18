import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../discussion/detail_post_screen.dart';
import 'package:bara/features/notification/screens/notification_screen.dart';
import 'package:bara/features/chat/screens/chat_list_screen.dart';
import 'package:bara/core/services/discussion_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkItem {
  final String id;
  final String title;
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String categoryTag;
  final String categoryType; // 'Study Notes', 'Live Chat', 'Materi Kuliah'
  final String snippet;
  final String? fileName;
  final String? fileSize;
  final String likes;
  final String comments;
  bool isBookmarked;

  _BookmarkItem({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    required this.categoryTag,
    required this.categoryType,
    required this.snippet,
    this.fileName,
    this.fileSize,
    required this.likes,
    required this.comments,
  }) : isBookmarked = true;
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'Semua',
    'Study Notes',
    'Live Chat',
    'Materi Kuliah',
  ];

  late List<_BookmarkItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _BookmarkItem(
        id: '1',
        title: 'Complete Guide to Advanced Graph Algorithms',
        authorName: 'Elena Rostova',
        authorRole: 'Top Mentor • Teknik Informatika',
        timeAgo: 'Oct 12',
        categoryTag: 'STUDY NOTES',
        categoryType: 'Study Notes',
        snippet:
            'Ringkasan lengkap mencakup BFS, DFS, Dijkstra, Bellman-Ford, hingga Floyd-Warshall beserta contoh implementasi Dart.',
        fileName: 'Graph_Algorithms_Complete.pdf',
        fileSize: '3.8 MB • 14 Pages',
        likes: '342',
        comments: '48',
      ),
      _BookmarkItem(
        id: '2',
        title: 'Diskusi Live: Persiapan UTS Pemrograman Berorientasi Objek',
        authorName: 'Bagas Pratama',
        authorRole: 'Mentor • Sistem Informasi',
        timeAgo: '2 hari lalu',
        categoryTag: 'LIVE CHAT',
        categoryType: 'Live Chat',
        snippet:
            'Arsip rekaman diskusi sesi live 3 jam membahas Polymorphism, Interface, Design Pattern Factory, dan kisi-kisi studi kasus.',
        likes: '215',
        comments: '136',
      ),
      _BookmarkItem(
        id: '3',
        title: 'Cheat Sheet: Normalisasi Database & Optimasi Query SQL',
        authorName: 'Aleca Cantika',
        authorRole: 'Sistem Informasi • Angkatan 22',
        timeAgo: '5 hari lalu',
        categoryTag: 'MATERI KULIAH',
        categoryType: 'Materi Kuliah',
        snippet:
            'Panduan langkah 1NF sampai BCNF dengan studi kasus marketplace kampus dan indexing query di PostgreSQL.',
        fileName: 'DB_Normalization_Guide.pdf',
        fileSize: '1.9 MB • 6 Pages',
        likes: '189',
        comments: '27',
      ),
      _BookmarkItem(
        id: '4',
        title: 'Rangkuman Materi Teori Graf & Komputabilitas',
        authorName: 'Dian Kusuma',
        authorRole: 'Teknik Komputer',
        timeAgo: '1 minggu lalu',
        categoryTag: 'STUDY NOTES',
        categoryType: 'Study Notes',
        snippet:
            'Kumpulan rumus, pembuktian induksi matematika, Finite Automata, dan Turing Machine semester 4.',
        likes: '142',
        comments: '19',
      ),
      _BookmarkItem(
        id: '5',
        title: 'Live Session: Bedah Arsitektur Microservices dengan Supabase',
        authorName: 'Farhan Maulana',
        authorRole: 'Software Engineer Mentor',
        timeAgo: '2 minggu lalu',
        categoryTag: 'LIVE CHAT',
        categoryType: 'Live Chat',
        snippet:
            'Diskusi interaktif seputar real-time subscriptions, edge functions, dan Row Level Security (RLS).',
        likes: '412',
        comments: '94',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_BookmarkItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    final selectedCategory = _filters[_selectedFilterIndex];

    return _items.where((item) {
      if (!item.isBookmarked) return false;

      final matchesFilter = selectedCategory == 'Semua' ||
          item.categoryType.toLowerCase() == selectedCategory.toLowerCase();

      final matchesQuery = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.snippet.toLowerCase().contains(query) ||
          item.authorName.toLowerCase().contains(query);

      return matchesFilter && matchesQuery;
    }).toList();
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailPostScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);
    final displayedItems = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // --- TOP APP BAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFCBD5E1),
                    backgroundImage:
                        AssetImage('assets/images/CloudArt_margin.png'),
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
                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                            color: textColorDark, size: 22),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatListScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded,
                            color: textColorDark, size: 22),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- SEARCH FIELD ---
              Container(
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
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: textColorDark,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari catatan atau materi tersimpan...',
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- HERO BANNER (FIGMA STYLE) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5382C1), Color(0xFF3B6CB4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: buttonBlue.withValues(alpha: 0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bookmark_rounded,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  'Koleksi Pribadi',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Materi & Catatan Tersimpan',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Akses cepat rangkuman, modul bimbingan, dan arsip live chat favoritmu.',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.collections_bookmark_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // --- FILTER CHIPS ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilterIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? buttonBlue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? buttonBlue
                                  : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: buttonBlue.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            _filters[index],
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),

              // --- SECTION TITLE WITH COUNT ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tersimpan (${displayedItems.length})',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textColorDark,
                    ),
                  ),
                  if (displayedItems.isNotEmpty)
                    Text(
                      'Terbaru',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: buttonBlue,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // --- LIST OF BOOKMARKED ITEMS ---
              if (displayedItems.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = displayedItems[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetail(context),
                      child: _buildBookmarkCard(item),
                    );
                  },
                ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              size: 40,
              color: Color(0xFF5382C1),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Belum ada materi tersimpan',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _searchController.text.isNotEmpty
                ? 'Tidak ada item yang cocok dengan pencarian kata kunci.'
                : 'Simpan materi, modul, dan diskusi favoritmu dengan menekan ikon bookmark.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(_BookmarkItem item) {
    Color tagBgColor;
    Color tagTextColor;

    switch (item.categoryType) {
      case 'Live Chat':
        tagBgColor = const Color(0xFFECFDF5);
        tagTextColor = const Color(0xFF059669);
        break;
      case 'Materi Kuliah':
        tagBgColor = const Color(0xFFFFF7ED);
        tagTextColor = const Color(0xFFEA580C);
        break;
      default:
        tagBgColor = const Color(0xFFEFF6FF);
        tagTextColor = const Color(0xFF2563EB);
    }

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
          // Author Header
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFCBD5E1),
                backgroundImage:
                    AssetImage('assets/images/CloudArt_margin.png'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.authorName,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      item.authorRole,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  item.isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: const Color(0xFF5382C1),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    item.isBookmarked = !item.isBookmarked;
                  });
                  try {
                    DiscussionService().toggleBookmark(item.id);
                  } catch (_) {}
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 1200),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      content: Text(
                        item.isBookmarked
                            ? 'Materi ditambahkan ke bookmark'
                            : 'Materi dihapus dari bookmark',
                        style: GoogleFonts.manrope(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Category Badge & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.categoryTag,
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: tagTextColor,
                  ),
                ),
              ),
              Text(
                item.timeAgo,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            item.title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 6),

          // Snippet
          Text(
            item.snippet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.4,
            ),
          ),

          // Optional File Attachment
          if (item.fileName != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf_rounded,
                      size: 20, color: Color(0xFFEF4444)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fileName!,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.fileSize != null)
                          Text(
                            item.fileSize!,
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Footer (Likes, Comments, Detail link)
          Row(
            children: [
              const Icon(Icons.favorite_border,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                item.likes,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                item.comments,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Buka Diskusi',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5382C1),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: Color(0xFF5382C1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
