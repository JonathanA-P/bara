import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/models/post_model.dart';

class AddDiscussionScreen extends StatefulWidget {
  final PostCategoryTab? initialTab;
  final Function(PostModel)? onPostCreated;
  final VoidCallback? onBack;

  const AddDiscussionScreen({
    super.key,
    this.initialTab,
    this.onPostCreated,
    this.onBack,
  });

  @override
  State<AddDiscussionScreen> createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  // Mode flag: false = Kelas (Topik mata kuliah), true = Luar Kelas (Topik luar kelas)
  late bool _isLuarKelas;

  // Controllers
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _matkulSearchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Focus node for Mata Kuliah search
  final FocusNode _matkulFocusNode = FocusNode();

  // Selected Program Studi
  String _selectedProdi = 'Teknik Informatika';
  bool _isProdiOpen = false;

  // Selected Mata Kuliah
  String? _selectedMatkul;
  bool _isMatkulOpen = false;

  // Attachment states
  String? _attachedImage;
  String? _attachedFileName;

  // 5 Program Studi as specified
  final List<String> _prodiList = const [
    'Teknik Informatika',
    'Teknik Komputer',
    'Sistem Informasi',
    'Teknologi Informasi',
    'Pendidikan Teknologi Informasi',
  ];

  // Course suggestions mapped to Prodi + general courses
  final Map<String, List<String>> _coursesByProdi = const {
    'Teknik Informatika': [
      'Pemrograman Dasar',
      'Pemrograman Web',
      'Pemrograman Mobile',
      'Algoritma & Struktur Data',
      'Basis Data',
      'Kecerdasan Buatan',
      'Rekayasa Perangkat Lunak',
      'Jaringan Komputer',
      'Sistem Operasi',
    ],
    'Teknik Komputer': [
      'Sistem Tertanam (Embedded System)',
      'Arsitektur Komputer',
      'Robotika & Otomasi',
      'Jaringan & Komunikasi Data',
      'Pengolahan Sinyal Digital',
      'Pemrograman Dasar',
      'Mikrokontroler',
    ],
    'Sistem Informasi': [
      'Manajemen Sistem Informasi',
      'Analisis & Desain Sistem',
      'Basis Data Terdistribusi',
      'Arsitektur Enterprise',
      'Tata Kelola TI',
      'Pemrograman Web',
      'Manajemen Proyek TI',
    ],
    'Teknologi Informasi': [
      'Keamanan Informasi',
      'Administrasi Jaringan',
      'Cloud Computing',
      'Internet of Things (IoT)',
      'Pemrograman Berorientasi Objek',
      'Integrasi Sistem',
    ],
    'Pendidikan Teknologi Informasi': [
      'Media Pembelajaran TI',
      'Kurikulum Pendidikan Vokasi',
      'Evaluasi Pembelajaran',
      'Pemrograman Dasar',
      'Desain Grafis & Multimedia',
      'Strategi Pembelajaran Komputer',
    ],
  };

  // Also include the 5 options as general searchable course topics
  final List<String> _fallbackAllCourses = const [
    'Pemrograman Dasar',
    'Pemrograman Web',
    'Pemrograman Mobile',
    'Algoritma & Struktur Data',
    'Basis Data',
    'Jaringan Komputer',
    'Sistem Operasi',
    'Teknik Informatika',
    'Teknik Komputer',
    'Sistem Informasi',
    'Teknologi Informasi',
    'Pendidikan Teknologi Informasi',
  ];

  @override
  void initState() {
    super.initState();
    _isLuarKelas = widget.initialTab == PostCategoryTab.luarKelas;

    _matkulSearchController.addListener(() {
      setState(() {});
    });

    _matkulFocusNode.addListener(() {
      if (_matkulFocusNode.hasFocus) {
        setState(() {
          _isMatkulOpen = true;
          _isProdiOpen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    _matkulSearchController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _matkulFocusNode.dispose();
    super.dispose();
  }

  List<String> _getFilteredMatkul() {
    final query = _matkulSearchController.text.trim().toLowerCase();
    final prodiCourses = _coursesByProdi[_selectedProdi] ?? _fallbackAllCourses;

    // Combine courses with fallback
    final all = <String>{...prodiCourses, ..._fallbackAllCourses}.toList();

    if (query.isEmpty) {
      return all;
    }
    return all.where((item) => item.toLowerCase().contains(query)).toList();
  }

  void _onToggleLuarKelas(bool? value) {
    setState(() {
      _isLuarKelas = value ?? !_isLuarKelas;
      _isProdiOpen = false;
      _isMatkulOpen = false;
      _matkulFocusNode.unfocus();
    });
  }

  void _handlePickPhoto() {
    setState(() {
      if (_attachedImage == null) {
        _attachedImage = 'assets/images/CloudArt_margin.png';
      } else {
        _attachedImage = null;
      }
    });
  }

  void _handlePickFile() {
    setState(() {
      if (_attachedFileName == null) {
        _attachedFileName = 'Modul_Kuliah.pdf (1.2 MB)';
      } else {
        _attachedFileName = null;
      }
    });
  }

  void _handleSubmitPost() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan judul postingan'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan isi postingan'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Build PostBadge list
    final List<PostBadge> badges = [];

    if (!_isLuarKelas) {
      // Topik Mata Kuliah badges
      badges.add(
        PostBadge(
          label: _selectedProdi.toUpperCase(),
          backgroundColor: const Color(0xFFF97316),
          textColor: Colors.white,
        ),
      );

      final matkulLabel = _selectedMatkul ??
          (_matkulSearchController.text.trim().isNotEmpty
              ? _matkulSearchController.text.trim()
              : 'MATAKULIAH');

      badges.add(
        PostBadge(
          label: matkulLabel.toUpperCase(),
          backgroundColor: const Color(0xFFE0F2FE),
          textColor: const Color(0xFF0284C7),
        ),
      );
    } else {
      // Topik Luar Kelas badge
      final topicLabel = _topicController.text.trim().isNotEmpty
          ? _topicController.text.trim()
          : 'LUAR KELAS';

      badges.add(
        PostBadge(
          label: topicLabel.toUpperCase(),
          backgroundColor: const Color(0xFFE0F2FE),
          textColor: const Color(0xFF0284C7),
        ),
      );
    }

    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Nadia Aulia',
      authorAvatar: 'assets/images/userLogo.png',
      timeAgo: 'Baru saja',
      userRole: _isLuarKelas
          ? 'HiGavi Community Enthusiast'
          : '$_selectedProdi • Angkatan 2023',
      tab: _isLuarKelas ? PostCategoryTab.luarKelas : PostCategoryTab.kuliah,
      badges: badges,
      title: title,
      content: content,
      imageAttachment: _attachedImage,
      fileAttachment: _attachedFileName,
      fileSize: _attachedFileName != null ? '1.2 MB' : null,
      likesCount: 0,
      commentsCount: 0,
    );

    widget.onPostCreated?.call(newPost);

    if (Navigator.canPop(context)) {
      Navigator.pop(context, newPost);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postingan berhasil dibuat!'),
          backgroundColor: Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Clear fields
      setState(() {
        _titleController.clear();
        _contentController.clear();
        _topicController.clear();
        _matkulSearchController.clear();
        _selectedMatkul = null;
        _attachedImage = null;
        _attachedFileName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textDark = Color(0xFF1E293B);
    const Color textMuted = Color(0xFF94A3B8);
    const Color borderGrey = Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TOP APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderGrey,
                            width: 1.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: textDark,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Tambah Postingan',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),

            // FORM BODY (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // USER PROFILE ROW
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFE2E8F0),
                          backgroundImage:
                              AssetImage('assets/images/userLogo.png'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nadia Aulia',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@nadiaulia',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // TOPIC TYPE CARD (Banner)
                    _buildTopicTypeCard(buttonBlue, textDark, textMuted, borderGrey),

                    const SizedBox(height: 20),

                    // CONDITIONAL FIELDS: KELAS vs LUAR KELAS
                    if (!_isLuarKelas) ...[
                      // --- KELAS MODE ---
                      _buildProgramStudiField(textDark, borderGrey),
                      const SizedBox(height: 16),
                      _buildMataKuliahField(textDark, textMuted, borderGrey),
                    ] else ...[
                      // --- LUAR KELAS MODE ---
                      _buildTopikField(textDark, textMuted, borderGrey),
                    ],

                    const SizedBox(height: 16),

                    // FIELD: JUDUL
                    _buildJudulField(textDark, textMuted, borderGrey),

                    const SizedBox(height: 16),

                    // FIELD: CONTENT TEXTAREA (with Foto & File inside)
                    _buildContentBox(textDark, textMuted, borderGrey),

                    const SizedBox(height: 24),

                    // POSTING BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleSubmitPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Posting',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TOPIC TYPE CARD ---
  Widget _buildTopicTypeCard(
    Color buttonBlue,
    Color textDark,
    Color textMuted,
    Color borderGrey,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: buttonBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.article_outlined,
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
                      !_isLuarKelas ? 'Topik mata kuliah' : 'Topik luar kelas',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      !_isLuarKelas
                          ? 'Post akan dikelompokkan berdasarkan prodi dan matkul.'
                          : 'Disini kamu bebas menulis apapun, tapi usahakan untuk tetap menggunakan bahasa yang sopan',
                      style: GoogleFonts.manrope(
                        fontSize: 10.5,
                        color: textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _onToggleLuarKelas(!_isLuarKelas),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _isLuarKelas ? buttonBlue : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _isLuarKelas ? buttonBlue : borderGrey,
                      width: 1.5,
                    ),
                  ),
                  child: _isLuarKelas
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  'Apakah ini topik luar kelas?',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PROGRAM STUDI DROPDOWN ---
  Widget _buildProgramStudiField(Color textDark, Color borderGrey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Program Studi',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderGrey),
          ),
          child: Column(
            children: [
              // Header Selector Row
              InkWell(
                onTap: () {
                  setState(() {
                    _isProdiOpen = !_isProdiOpen;
                    _isMatkulOpen = false;
                    _matkulFocusNode.unfocus();
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedProdi,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ),
                      Icon(
                        _isProdiOpen
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.chevron_right_rounded,
                        color: const Color(0xFF64748B),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded Options List (As shown in screenshot 2 left)
              if (_isProdiOpen) ...[
                const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _prodiList.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  itemBuilder: (context, index) {
                    final prodi = _prodiList[index];
                    final isSelected = prodi == _selectedProdi;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedProdi = prodi;
                          _isProdiOpen = false;
                          _selectedMatkul = null;
                          _matkulSearchController.clear();
                        });
                      },
                      child: Container(
                        color: isSelected
                            ? const Color(0xFFE2E8F0)
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          prodi,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // --- MATA KULIAH FIELD ---
  Widget _buildMataKuliahField(
    Color textDark,
    Color textMuted,
    Color borderGrey,
  ) {
    final filtered = _getFilteredMatkul();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mata Kuliah',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isMatkulOpen ? const Color(0xFF5382C1) : borderGrey,
            ),
          ),
          child: Column(
            children: [
              // Input Field / Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _matkulSearchController,
                        focusNode: _matkulFocusNode,
                        onTap: () {
                          setState(() {
                            _isMatkulOpen = true;
                            _isProdiOpen = false;
                          });
                        },
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: _selectedMatkul ?? 'Cari matkul',
                          hintStyle: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: _selectedMatkul != null
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedMatkul != null ? textDark : textMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMatkulOpen = !_isMatkulOpen;
                          _isProdiOpen = false;
                          if (_isMatkulOpen) {
                            _matkulFocusNode.requestFocus();
                          } else {
                            _matkulFocusNode.unfocus();
                          }
                        });
                      },
                      child: Icon(
                        _isMatkulOpen
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.chevron_right_rounded,
                        color: const Color(0xFF64748B),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded Suggestions List (As shown in screenshot 2 right)
              if (_isMatkulOpen) ...[
                const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: filtered.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Gunakan "${_matkulSearchController.text.trim()}" sebagai matkul baru',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF5382C1),
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const Divider(
                              height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                          itemBuilder: (context, index) {
                            final matkul = filtered[index];
                            final isSelected = matkul == _selectedMatkul;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedMatkul = matkul;
                                  _matkulSearchController.text = matkul;
                                  _isMatkulOpen = false;
                                  _matkulFocusNode.unfocus();
                                });
                              },
                              child: Container(
                                color: isSelected
                                    ? const Color(0xFFE2E8F0)
                                    : Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                child: Text(
                                  matkul,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E3A8A),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // --- TOPIK FIELD (For Luar Kelas) ---
  Widget _buildTopikField(Color textDark, Color textMuted, Color borderGrey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topik',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _topicController,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan Topik. Contoh: Gosipan',
            hintStyle: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textMuted,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5382C1)),
            ),
          ),
        ),
      ],
    );
  }

  // --- JUDUL FIELD ---
  Widget _buildJudulField(Color textDark, Color textMuted, Color borderGrey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Judul',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan Judul. Contoh: Gosipan',
            hintStyle: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textMuted,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5382C1)),
            ),
          ),
        ),
      ],
    );
  }

  // --- CONTENT TEXTAREA (With Foto and File buttons) ---
  Widget _buildContentBox(Color textDark, Color textMuted, Color borderGrey) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _contentController,
            maxLines: 6,
            minLines: 5,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textDark,
            ),
            decoration: InputDecoration(
              hintText:
                  'Bagikan pertanyaan, insight, atau informasi untuk teman kampus...',
              hintStyle: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textMuted,
                height: 1.4,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),

          // Attachment previews (if any)
          if (_attachedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      _attachedImage!,
                      height: 80,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => setState(() => _attachedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_attachedFileName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Chip(
                avatar: const Icon(Icons.insert_drive_file_outlined, size: 16),
                label: Text(
                  _attachedFileName!,
                  style: GoogleFonts.manrope(fontSize: 11),
                ),
                onDeleted: () => setState(() => _attachedFileName = null),
                deleteIconColor: Colors.grey,
              ),
            ),

          const SizedBox(height: 6),

          // Foto and File outline buttons inside bottom-left
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                // Foto button
                InkWell(
                  onTap: _handlePickPhoto,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderGrey),
                      color: _attachedImage != null
                          ? const Color(0xFFF1F5F9)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 16,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Foto',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // File button
                InkWell(
                  onTap: _handlePickFile,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderGrey),
                      color: _attachedFileName != null
                          ? const Color(0xFFF1F5F9)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'File',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
