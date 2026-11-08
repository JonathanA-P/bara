import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login/login_screen.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final Color buttonColor;
  final Color activeDotColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonColor,
    required this.activeDotColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Temukan Teman\nBelajar Baru',
      description:
          'Kenali teman baru yang bisa diajak belajar, berdiskusi, dan saling membantu memahami materi kuliah.',
      imagePath: 'assets/images/CloudArt_margin.png',
      buttonColor: const Color(0xFF5A7FBA),
      activeDotColor: const Color(0xFF5A7FBA),
    ),
    OnboardingItem(
      title: 'Berbagi Informasi\nBersama Komunitas',
      description:
          'Bagikan catatan, bertukar informasi, dan diskusikan tugas bersama komunitas kampus untuk belajar lebih seru.',
      imagePath: 'assets/images/CloudArt_margin_1.png',
      buttonColor: const Color(0xFF3882C7),
      activeDotColor: const Color(0xFF3882C7),
    ),
    OnboardingItem(
      title: 'Tanyakan Kapan dan\nDimana Saja',
      description:
          'Temukan jawaban atas pertanyaan kuliah, pahami materi, dan dapatkan rangkuman serta latihan soal kapan pun kamu butuh.',
      imagePath: 'assets/images/CloudArt_margin_2.png',
      buttonColor: const Color(0xFF3882C7),
      activeDotColor: const Color(0xFF3882C7),
    ),
  ];

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _items[_currentIndex];
    final bool isLastPage = _currentIndex == _items.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP BAR (LOGO + SKIP BUTTON) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logohigavi.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'HiGavi',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: const Color(0xFF1E293B),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: _navigateToLogin,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- PAGEVIEW (ILLUSTRATION, INDICATOR, TEXT) ---
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- DOT INDICATORS ---
                        Row(
                          children: List.generate(_items.length, (dotIndex) {
                            final bool isActive = _currentIndex == dotIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 6),
                              height: 6,
                              width: isActive ? 26 : 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? item.activeDotColor
                                    : const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // --- TITLE ---
                        Text(
                          item.title,
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // --- DESCRIPTION ---
                        Text(
                          item.description,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- BOTTOM ACTION BUTTON ---
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 28.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentItem.buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastPage ? 'Bergabung Sekarang' : 'Selanjutnya',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
