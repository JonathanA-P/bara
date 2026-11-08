import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/features/quiz/screens/competency_quiz_screen.dart';
import 'package:bara/core/services/matching_service.dart';

class MentorCardData {
  final String id;
  final String name;
  final String major;
  final String semester;
  final double rating;
  final int reviewsCount;
  final String tagline;
  final String bio;
  final List<String> skills;
  final String availability;

  MentorCardData({
    required this.id,
    required this.name,
    required this.major,
    required this.semester,
    required this.rating,
    required this.reviewsCount,
    required this.tagline,
    required this.bio,
    required this.skills,
    required this.availability,
  });
}

class MentorMatchingScreen extends StatefulWidget {
  const MentorMatchingScreen({super.key});

  @override
  State<MentorMatchingScreen> createState() => _MentorMatchingScreenState();
}

class _MentorMatchingScreenState extends State<MentorMatchingScreen> {
  int _currentIndex = 0;

  late List<MentorCardData> _mentors;

  @override
  void initState() {
    super.initState();
    _mentors = [
      MentorCardData(
        id: '1',
        name: 'Farhan Maulana',
        major: 'Teknik Informatika',
        semester: 'Semester 6',
        rating: 4.9,
        reviewsCount: 84,
        tagline: 'Master Algoritma & Kompetitif Pemrograman',
        bio:
            'Membantu mahasiswa tingkat 1 & 2 memahami struktur data pohon, graf, dan dynamic programming dengan analogi praktis.',
        skills: ['Graf & Tree', 'Dynamic Programming', 'Flutter Dart', 'C++'],
        availability: 'Malam ini (19.00 - 21.00)',
      ),
      MentorCardData(
        id: '2',
        name: 'Aleca Cantika',
        major: 'Sistem Informasi',
        semester: 'Semester 6',
        rating: 4.8,
        reviewsCount: 62,
        tagline: 'Database Designer & Business Analyst',
        bio:
            'Spesialis normalisasi tabel, optimasi query relasional, hingga penyusunan dokumen SRS untuk tugas akhir semester.',
        skills: ['PostgreSQL', 'ERD & DFD', 'Figma UI/UX', 'System Analysis'],
        availability: 'Besok (14.00 - 17.00)',
      ),
      MentorCardData(
        id: '3',
        name: 'Bagas Pratama',
        major: 'Teknik Informatika',
        semester: 'Semester 8',
        rating: 5.0,
        reviewsCount: 110,
        tagline: 'Full-stack Engineer & Software Architect',
        bio:
            'Berpengalaman magang di tech industry. Siap mentoring OOP tingkat lanjut, Clean Code, dan RESTful API.',
        skills: ['Clean Architecture', 'OOP Java', 'Spring Boot', 'Docker'],
        availability: 'Akhir Pekan (Sabtu-Minggu)',
      ),
      MentorCardData(
        id: '4',
        name: 'Dian Kusuma',
        major: 'Teknik Komputer',
        semester: 'Semester 6',
        rating: 4.7,
        reviewsCount: 45,
        tagline: 'Network & Operating System Enthusiast',
        bio:
            'Kupas tuntas subnetting, konfigurasi router Mikrotik, hingga manajemen memory dan process thread pada OS.',
        skills: ['Jaringan Komputer', 'Linux Kernel', 'Computer Architecture'],
        availability: 'Kamis (16.00 - 18.00)',
      ),
    ];
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    try {
      final list = await MatchingService().getAvailableMentors();
      if (list.isNotEmpty && mounted) {
        setState(() {
          _mentors = list.map((m) {
            final prof = m['profiles'] as Map<String, dynamic>?;
            return MentorCardData(
              id: m['id']?.toString() ?? '1',
              name: prof?['full_name'] as String? ?? 'Mentor FILKOM',
              major: prof?['major'] as String? ?? 'Teknik Informatika',
              semester: 'Semester ${m['semester'] ?? 6}',
              rating: (m['rating'] as num?)?.toDouble() ?? 4.9,
              reviewsCount: (m['review_count'] as num?)?.toInt() ?? 24,
              tagline: m['headline'] as String? ?? 'Master Algoritma & Pemrograman',
              bio: prof?['bio'] as String? ?? m['bio'] as String? ?? 'Siap membimbing materi perkuliahan.',
              skills: (m['skills'] is List)
                  ? List<String>.from(m['skills'])
                  : ['Algoritma', 'Pemrograman'],
              availability: 'Malam ini (19.00 - 21.00)',
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('[MentorMatching] Load mentors error: $e');
    }
  }

  void _swipeNext(bool isMatch) {
    if (_currentIndex >= _mentors.length) return;

    final mentor = _mentors[_currentIndex];
    setState(() {
      _currentIndex++;
    });

    try {
      MatchingService().swipeMentor(mentorId: mentor.id, isLike: isMatch);
    } catch (_) {}

    if (isMatch) {
      _showMatchSuccessDialog(mentor);
    }
  }

  void _showMatchSuccessDialog(MentorCardData mentor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2563EB),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mentor Terpilih!',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu memilih ${mentor.name} sebagai seniormu. Untuk persiapan belajar terbaik, ikuti kuis validasi pemahaman awal.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Nanti',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompetencyQuizScreen(
                            mentorName: mentor.name,
                            topic: mentor.skills.first,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5382C1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Mulai Kuis',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
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
  }

  @override
  Widget build(BuildContext context) {
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: textColorDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Matchmaking Mentor',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColorDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: textColorDark),
            onPressed: () => setState(() => _currentIndex = 0),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card deck area
              Expanded(
                child: _currentIndex >= _mentors.length
                    ? _buildCompletedDeck()
                    : _buildMentorCardDeck(_mentors[_currentIndex]),
              ),

              const SizedBox(height: 16),

              // Action buttons (Pass, Match)
              if (_currentIndex < _mentors.length)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reject / Pass button
                    GestureDetector(
                      onTap: () => _swipeNext(false),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFFEF4444),
                          size: 30,
                        ),
                      ),
                    ),

                    // Info button
                    GestureDetector(
                      onTap: () {
                        final mentor = _mentors[_currentIndex];
                        _showMatchSuccessDialog(mentor);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          color: Color(0xFF64748B),
                          size: 22,
                        ),
                      ),
                    ),

                    // Accept / Match button
                    GestureDetector(
                      onTap: () => _swipeNext(true),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMentorCardDeck(MentorCardData mentor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner with Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 130,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF5382C1), Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFDE047), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${mentor.rating} (${mentor.reviewsCount} review)',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: -32,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFFCBD5E1),
                    backgroundImage:
                        AssetImage('assets/images/CloudArt_margin.png'),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Mentor Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            mentor.name,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mentor.semester,
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      mentor.major,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tagline
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        '💡 "${mentor.tagline}"',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Tentang Mentor',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mentor.bio,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Keahlian Utama',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: mentor.skills.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Text(
                            s,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1D4ED8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 14),

                    // Availability
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded,
                            size: 16, color: Color(0xFF10B981)),
                        const SizedBox(width: 6),
                        Text(
                          'Ketersediaan: ${mentor.availability}',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedDeck() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.done_all_rounded,
              color: Color(0xFF2563EB),
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Semua Mentor Telah Dilihat',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kamu dapat mengatur ulang pilihan untuk melihat kembali profil mentor.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => setState(() => _currentIndex = 0),
            icon: const Icon(Icons.replay_rounded, size: 18),
            label: Text(
              'Ulangi Matchmaking',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5382C1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

