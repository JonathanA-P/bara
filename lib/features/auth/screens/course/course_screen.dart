import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final PageController _pageController = PageController();
  int _currentBannerIndex = 0;

  List<String> selectedProdi = ['Teknik Informatika'];
  int? selectedSemester = 3;
  String selectedSort = 'terbaik';

  final _banners = [
    {
      'subtitle': 'KULIAH NGAK PERNAH SESERU INI',
      'title': 'Pelajari dan persiapkan semestermu',
      'desc': 'TEMUKAN MATKUL YANG SESUAI DENGAN RENCANA STUDIMU.',
      'image': 'assets/images/matkul1.png',
    },
    {
      'subtitle': 'PERSIAPKAN DIRI LEBIH MATANG',
      'title': 'Rating menunjukkan tingkat kesulitan',
      'desc': 'SEMAKIN TINGGI RATING, SEMAKIN MENANTANG MATKULNYA.',
      'image': 'assets/images/matkul2.png',
    },
    {
      'subtitle': 'KENALI DOSEN MATA KULIAH',
      'title': 'Prediksi dosen tidak selalu 100% tepat',
      'desc': 'PREDIKSI DIBUAT BERDASARKAN DATA YANG TERSEDIA.',
      'image': 'assets/images/matkul3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _activeFilterCount {
    int count = selectedProdi.length;
    if (selectedSemester != null) count++;
    return count;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final prodiOptions = [
              {'name': 'Teknik Informatika', 'count': '18 matkul'},
              {'name': 'Teknik Komputer', 'count': '18 matkul'},
              {'name': 'Sistem Informasi', 'count': '12 matkul'},
              {'name': 'Teknologi Informasi', 'count': '9 matkul'},
              {'name': 'Pendidikan Teknologi Informasi', 'count': '9 matkul'},
            ];

            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Filter Mata Kuliah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary2_900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pilih kategori yang ingin ditampilkan',
                    style: TextStyle(fontSize: 12, color: AppColors.grey800),
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Program Studi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary2_900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...prodiOptions.map((prodi) {
                            final isChecked = selectedProdi.contains(
                              prodi['name'],
                            );
                            return CheckboxListTile(
                              value: isChecked,
                              activeColor: AppColors.primary1_500,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                prodi['name']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isChecked
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: AppColors.primary2_900,
                                ),
                              ),
                              secondary: Text(
                                prodi['count']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey600,
                                ),
                              ),
                              onChanged: (val) {
                                setModalState(() {
                                  if (val == true) {
                                    selectedProdi.add(prodi['name']!);
                                  } else {
                                    selectedProdi.remove(prodi['name']);
                                  }
                                });
                              },
                            );
                          }),
                          const SizedBox(height: 16),
                          const Text(
                            'Semester Kuliah',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary2_900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 2.2,
                                ),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              final semNum = index + 1;
                              final isSelected = selectedSemester == semNum;
                              return InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedSemester = isSelected
                                        ? null
                                        : semNum;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary1_50
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary1_500
                                          : AppColors.grey300,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$semNum',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppColors.primary1_500
                                          : AppColors.primary2_900,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              selectedProdi.clear();
                              selectedSemester = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.grey300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.primary2_900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.primary1_500,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Terapkan Filter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Urutkan Mata Kuliah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary2_900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pilih urutan berdasarkan rating kesulitan',
                    style: TextStyle(fontSize: 12, color: AppColors.grey800),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    value: 'terbaik',
                    groupValue: selectedSort,
                    activeColor: AppColors.primary1_500,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Rating terbaik',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary2_900,
                      ),
                    ),
                    subtitle: const Text(
                      'Tingkat kesulitan tertinggi lebih dulu',
                      style: TextStyle(fontSize: 11, color: AppColors.grey800),
                    ),
                    onChanged: (val) {
                      setModalState(() => selectedSort = val!);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'terburuk',
                    groupValue: selectedSort,
                    activeColor: AppColors.primary1_500,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Rating terburuk',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary2_900,
                      ),
                    ),
                    subtitle: const Text(
                      'Tingkat kesulitan terendah lebih dulu',
                      style: TextStyle(fontSize: 11, color: AppColors.grey800),
                    ),
                    onChanged: (val) {
                      setModalState(() => selectedSort = val!);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary1_500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Terapkan Urutan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCarousel(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.grey800,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cari mata kuliah',
                              style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _showFilterBottomSheet,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _activeFilterCount > 0
                                ? AppColors.primary1_500
                                : AppColors.grey200,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.tune_rounded,
                              color: AppColors.primary1_500,
                              size: 22,
                            ),
                            if (_activeFilterCount > 0)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary1_500,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$_activeFilterCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_activeFilterCount > 0) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ...selectedProdi.map(
                        (prodi) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            label: prodi,
                            onRemove: () {
                              setState(() => selectedProdi.remove(prodi));
                            },
                          ),
                        ),
                      ),
                      if (selectedSemester != null)
                        _buildFilterChip(
                          label: 'Semester $selectedSemester',
                          onRemove: () {
                            setState(() => selectedSemester = null);
                          },
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Mata Kuliah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary2_900,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showSortBottomSheet,
                      child: const Text(
                        'Urutkan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary1_500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildCourseCard(
                      badgeText: 'Wajib',
                      badgeColor: const Color(0xFFDCFCE7),
                      badgeTextColor: const Color(0xFF15803D),
                      code: 'IF2123',
                      title: 'Algoritma & Pemrograman',
                      sks: '4 SKS',
                      semester: 'Semester 3',
                      rating: '4.2',
                      showGradeBadge: true,
                      grade: 'A',
                    ),
                    const SizedBox(height: 12),
                    _buildCourseCard(
                      badgeText: 'Pilihan',
                      badgeColor: const Color(0xFFFEF3C7),
                      badgeTextColor: const Color(0xFFB45309),
                      code: 'MA1101',
                      title: 'Kalkulus Dasar',
                      sks: '4 SKS',
                      semester: 'Semester 3',
                      rating: '4.2',
                      showGradeBadge: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    '- Lihat Semua -',
                    style: TextStyle(
                      color: AppColors.primary1_500,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCarousel() {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary1_500,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['subtitle']!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['desc']!,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        banner['image']!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.book_rounded,
                            size: 70,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 12,
            left: 20,
            child: Row(
              children: List.generate(
                _banners.length,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: _currentBannerIndex == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentBannerIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary1_500,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard({
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String code,
    required String title,
    required String sks,
    required String semester,
    required String rating,
    required bool showGradeBadge,
    String grade = 'A',
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/brain.png',
                        width: 18,
                        height: 18,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.psychology_rounded,
                            size: 18,
                            color: Colors.pinkAccent,
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                code,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary1_500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary2_900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$sks  •  $semester',
                style: const TextStyle(fontSize: 11, color: AppColors.grey800),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary1_500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Lihat Detail Matkul',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showGradeBadge)
            Positioned(
              right: 12,
              bottom: 50,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B21A8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  grade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
