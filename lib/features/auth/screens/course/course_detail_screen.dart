import 'package:flutter/material.dart';
import 'course_rating_screen.dart';
import 'add_course_rating_screen.dart';

typedef RpsData = Map<String, String>;

class CourseDetailScreen extends StatefulWidget {
  final String code;
  final String title;
  final String category;
  final int sks;
  final int semester;
  final double rating;

  const CourseDetailScreen({
    Key? key,
    this.code = 'IF2123',
    this.title = 'Algoritma &\nPemrograman',
    this.category = 'MATA KULIAH WAJIB',
    this.sks = 4,
    this.semester = 3,
    this.rating = 4.2,
  }) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool _isRpsExpanded = false;

  final List<RpsData> _rpsList = [
    {'title': 'Tipe Data & Variabel', 'subtitle': 'Minggu 1'},
    {'title': 'Tipe Data & Variabel', 'subtitle': 'Minggu 2'},
    {'title': 'Tipe Data & Variabel', 'subtitle': 'Minggu 3'},
    {'title': 'Pengkondisian & Loop', 'subtitle': 'Minggu 4'},
    {'title': 'Function & Method', 'subtitle': 'Minggu 5'},
    {'title': 'Array & List', 'subtitle': 'Minggu 6'},
  ];

  @override
  Widget build(BuildContext context) {
    final displayedRps = _isRpsExpanded ? _rpsList : _rpsList.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Detail Mata Kuliah',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderBanner(),
              const SizedBox(height: 20),
              _buildCourseStats(),
              const SizedBox(height: 24),
              _buildRpsSection(displayedRps),
              const SizedBox(height: 24),
              _buildPrerequisiteSection(),
              const SizedBox(height: 24),
              _buildLecturerHistorySection(),
              const SizedBox(height: 24),
              _buildRatingCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2B6CB0),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.category,
                  style: const TextStyle(
                    color: Color(0xFF2B6CB0),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.code,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 200,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 220,
                child: Text(
                  'Fondasi pemecahan masalah komputasional dengan algoritma yang efektif.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -10,
            top: 10,
            child: Image.asset(
              'assets/bara_naik_pesawat.png',
              width: 110,
              height: 110,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 80, color: Colors.white54);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('SKS', '${widget.sks} SKS', isPrimary: true),
        _buildStatItem('Semester', '${widget.semester}', isPrimary: true),
        GestureDetector(
          onTap: () {
            CourseRatingScreen.showPreviewBottomSheet(
              context,
              rating: widget.rating,
              totalRating: 48,
            );
          },
          child: Column(
            children: [
              const Text(
                'Kesulitan',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('🧠 ', style: TextStyle(fontSize: 14)),
                  Text(
                    '${widget.rating}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFED8936),
                    ),
                  ),
                ],
              ),
              const Text(
                '48 rating',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {bool isPrimary = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isPrimary ? const Color(0xFF2B6CB0) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRpsSection(List<RpsData> displayedRps) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rencana Pembelajaran Semester',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isRpsExpanded = !_isRpsExpanded;
                });
              },
              child: Text(
                _isRpsExpanded ? 'Sembunyikan' : 'Lihat semua',
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ...displayedRps
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF63B3ED).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.article_outlined,
                              color: Color(0xFF2B6CB0),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2B6CB0),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['subtitle']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              if (!_isRpsExpanded)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '....',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrerequisiteSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text('Prasyarat', style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          'Dasar Pemrograman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildLecturerHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Histori dosen pengajar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        _buildLecturerItem('Dr. Budi Santoso, S.Kom., M.T.', 0.84, '84%'),
        const SizedBox(height: 12),
        _buildLecturerItem('Nadia Prameswari, M.Cs.', 0.68, '68%'),
        const SizedBox(height: 12),
        _buildLecturerItem('Rizky Mahendra, M.Kom.', 0.42, '42%'),
      ],
    );
  }

  Widget _buildLecturerItem(String name, double progress, String percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 12, color: Color(0xFF4A5568)),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B6CB0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3182CE)),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Probabilitas mengajar',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRatingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF3182CE),
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Punya pengalaman di matkul ini?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 26.0, top: 2.0),
            child: Text(
              'Bantu mahasiswa lain dengan memberi rating',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A85C1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCourseRatingScreen(),
                  ),
                );
              },
              child: const Text(
                'Beri rating',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
