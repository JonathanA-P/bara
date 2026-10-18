import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';
import '../discussion/add_discussion_screen.dart';
import '../bookmark/bookmark_screen.dart';
import 'package:bara/features/explore/screens/explore_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const BookmarkScreen(),
    const ProfileScreen(),
  ];

  void _openAddDiscussionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddDiscussionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF5382C1);
    const Color inactiveGrey = Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            elevation: 10,
            color: Colors.white,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => setState(() => _currentIndex = 0),
                    icon: SvgPicture.asset(
                      'assets/images/home.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 0 ? activeBlue : inactiveGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    icon: Icon(
                      Icons.explore_outlined,
                      size: 26,
                      color: _currentIndex == 1 ? activeBlue : inactiveGrey,
                    ),
                  ),
                  const SizedBox(width: 50),
                  IconButton(
                    onPressed: () => setState(() => _currentIndex = 2),
                    icon: SvgPicture.asset(
                      'assets/images/bookmark.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 2 ? activeBlue : inactiveGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _currentIndex = 3),
                    icon: Icon(
                      Icons.person_rounded,
                      size: 26,
                      color: _currentIndex == 3 ? activeBlue : inactiveGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -26, 
            child: GestureDetector(
              onTap: _openAddDiscussionModal,
              child: Image.asset(
                'assets/images/ai_button.png', 
                width: 130,  
                height: 130,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}