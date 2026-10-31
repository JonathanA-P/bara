import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import '../course/course_screen.dart';
import '../profile/profile_screen.dart';
import '../discussion/add_discussion_screen.dart';
import '../../../explore/screens/explore_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    CourseScreen(),
    Scaffold(body: Center(child: Text('Chat Screen'))),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF4C7BB8);
    const Color inactiveGrey = Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  activeIcon: Icons.home_rounded,
                  inactiveIcon: Icons.home_outlined,
                  activeColor: activeBlue,
                  inactiveColor: inactiveGrey,
                ),
                _buildNavItem(
                  index: 1,
                  activeIcon: Icons.explore_rounded,
                  inactiveIcon: Icons.explore_outlined,
                  activeColor: activeBlue,
                  inactiveColor: inactiveGrey,
                ),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 2),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/images/bookmark.svg',
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 2 ? activeBlue : inactiveGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 3),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/images/chatbar.png',
                          width: 22,
                          height: 22,
                          color: _currentIndex == 3 ? activeBlue : inactiveGrey,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            _currentIndex == 3
                                ? Icons.chat_bubble_rounded
                                : Icons.chat_bubble_outline_rounded,
                            size: 24,
                            color: _currentIndex == 3
                                ? activeBlue
                                : inactiveGrey,
                          ),
                        ),
                        Positioned(
                          top: -2,
                          right: -3,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildNavItem(
                  index: 4,
                  activeIcon: Icons.person_rounded,
                  inactiveIcon: Icons.person_outline_rounded,
                  activeColor: activeBlue,
                  inactiveColor: inactiveGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 25,
          color: isSelected ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}
