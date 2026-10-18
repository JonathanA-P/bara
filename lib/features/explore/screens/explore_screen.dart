import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/features/auth/screens/discussion/detail_post_screen.dart';
import 'package:bara/features/matching/screens/mentor_matching_screen.dart';
import 'package:bara/core/services/matching_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _MentorItem {
  final String id;
  final String name;
  final String major;
  final String role;
  final double rating;
  final int totalSessions;
  final List<String> tags;
  final String bio;

  _MentorItem({
    required this.id,
    required this.name,
    required this.major,
    required this.role,
    required this.rating,
    required this.totalSessions,
    required this.tags,
    required this.bio,
  });
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Semua', 'Mentor', 'Materi Kuliah', 'Study Group'];

  String _selectedMajor = 'Semua Jurusan';
  final List<String> _majors = [
    'Semua Jurusan',
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Pendidikan TI',
    'Teknologi Informasi',
  ];

  final List<_MentorItem> _mentors = [
    _MentorItem(
      id: '1',
      name: 'Farhan Maulana',
      major: 'Teknik Informatika',
      role: 'Top Mentor • Semester 6',
      rating: 4.9,
      totalSessions: 84,
      tags: ['Struktur Data', 'Algoritma', 'Flutter'],
      bio: 'Siap bantu kamu taklukkan DSA dan projek akhir framework modern.',
    ),
    _BookmarkExploreItem(
      id: '2',
      name: 'Aleca Cantika',
      major: 'Sistem Informasi',
      role: 'Expert Mentor • Semester 6',
      rating: 4.8,
      totalSessions: 62,
      tags: ['Basis Data', 'UI/UX Design', 'SQL'],
      bio: 'Bimbingan santai dan terstruktur untuk perancangan sistem dan DB.',
    ),
    _MentorItem(
      id: '3',
      name: 'Bagas Pratama',
      major: 'Teknik Informatika',
      role: 'Mentor • Semester 8',
      rating: 5.0,
      totalSessions: 110,
      tags: ['PBO', 'Java', 'Clean Architecture'],
      bio: 'Fokus persiapan UTS/UAS dan pemahaman konsep fundamental OOP.',
    ),
    _MentorItem(
      id: '4',
      name: 'Dian Kusuma',
      major: 'Teknik Komputer',
      role: 'Mentor • Semester 6',
      rating: 4.7,
      totalSessions: 45,
      tags: ['Jaringan Komputer', 'Sistem Operasi', 'C++'],
      bio: 'Bongkar konsep jaringan dan sistem low-level tanpa pusing rumus.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    try {
      final list = await MatchingService().getAvailableMentors();
      if (list.isNotEmpty && mounted) {
        setState(() {
          _mentors.clear();
          _mentors.addAll(list.map((item) {
            final profile = item['profiles'] as Map<String, dynamic>?;
            final name = profile?['full_name'] as String? ?? item['full_name'] as String? ?? 'Mentor FILKOM';
            final major = profile?['major'] as String? ?? item['major'] as String? ?? 'FILKOM UB';
            final bio = profile?['bio'] as String? ?? item['bio'] as String? ?? '';
            final skills = (item['skills'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
            final rating = (item['rating'] as num?)?.toDouble() ?? 5.0;
            final total = (item['review_count'] as num?)?.toInt() ?? 0;
            return _MentorItem(
              id: item['id']?.toString() ?? '',
              name: name,
              major: major,
              role: 'Mentor • Terverifikasi',
              rating: rating,
              totalSessions: total,
              tags: skills,
              bio: bio,
            );
          }));
        });
      }
    } catch (e) {
      debugPrint('[ExploreScreen] load mentors: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_MentorItem> get _filteredMentors {
    final query = _searchController.text.trim().toLowerCase();
    return _mentors.where((m) {
      final matchMajor =
          _selectedMajor == 'Semua Jurusan' || m.major == _selectedMajor;
      final matchQuery = query.isEmpty ||
          m.name.toLowerCase().contains(query) ||
          m.major.toLowerCase().contains(query) ||
          m.tags.any((t) => t.toLowerCase().contains(query));
      return matchMajor && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);
    final displayedMentors = _filteredMentors;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: RefreshIndicator(
          color: buttonBlue,
          onRefresh: _loadMentors,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // --- TOP BAR ---
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
                    'Eksplorasi',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: textColorDark,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: textColorDark),
                    onPressed: _showFilterBottomSheet,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- SEARCH BAR ---
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
                    hintText: 'Cari mentor, mata kuliah, atau topik belajar...',
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

              // --- CATEGORY PILLS ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryIndex = index),
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
                            _categories[index],
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

              const SizedBox(height: 18),

              // --- HERO DISCOVERY CARD ---
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MentorMatchingScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF5382C1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: buttonBlue.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
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
                            child: Text(
                              'MATCHMAKING 1-ON-1',
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Temukan Mentor Sesuai Gaya Belajarmu',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pilih teman sebaya yang telah terverifikasi kompetensinya di FILKOM.',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              ),

              const SizedBox(height: 20),

              // --- SECTION HEADER: TOP MENTOR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mentor FILKOM Terverifikasi (${displayedMentors.length})',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textColorDark,
                    ),
                  ),
                  Text(
                    _selectedMajor,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: buttonBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (displayedMentors.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedMentors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mentor = displayedMentors[index];
                    return _buildMentorCard(mentor);
                  },
                ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded,
              size: 40, color: Color(0xFF94A3B8)),
          const SizedBox(height: 10),
          Text(
            'Tidak ada mentor yang cocok',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba ubah kata kunci atau ganti filter jurusan.',
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(_MentorItem mentor) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFCBD5E1),
                backgroundImage:
                    AssetImage('assets/images/CloudArt_margin.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.name,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColorDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mentor.role,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFD97706)),
                    const SizedBox(width: 4),
                    Text(
                      mentor.rating.toString(),
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            mentor.bio,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: const Color(0xFF475569),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 10),

          // Skills tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: mentor.tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${mentor.totalSessions} sesi bimbingan selesai',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPostScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Minta Bimbingan',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Berdasarkan Jurusan',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _majors.map((major) {
                  final isSelected = _selectedMajor == major;
                  return ChoiceChip(
                    label: Text(major),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedMajor = major);
                      Navigator.pop(context);
                    },
                    selectedColor: const Color(0xFF5382C1),
                    labelStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _BookmarkExploreItem extends _MentorItem {
  _BookmarkExploreItem({
    required super.id,
    required super.name,
    required super.major,
    required super.role,
    required super.rating,
    required super.totalSessions,
    required super.tags,
    required super.bio,
  });
}
