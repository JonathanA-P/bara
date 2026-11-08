import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/services/app_data_controller.dart';
import 'home_screen.dart';
import '../course/course_screen.dart';
import '../profile/profile_screen.dart';
import '../../../explore/screens/explore_screen.dart';
import '../../../chat/screens/notification_chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  final AppDataController _dataController = AppDataController.instance;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    CourseScreen(),
    NotificationChatScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _dataController.addListener(_onDataUpdated);
  }

  void _onDataUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dataController.removeListener(_onDataUpdated);
    super.dispose();
  }

  void _onSelectTab(int index) {
    if (_currentIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF5A7FBA);
    const Color inactiveGrey = Color(0xFF94A3B8);
    final bool hasUnread =
        _dataController.totalUnreadChatsCount > 0 && _currentIndex != 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBody: true,
      body: Stack(
        children: List.generate(_screens.length, (index) {
          final bool isActive = _currentIndex == index;
          final double slideDx = isActive
              ? 0.0
              : (index > _currentIndex ? 0.03 : -0.03);

          return IgnorePointer(
            ignoring: !isActive,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              opacity: isActive ? 1.0 : 0.0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                offset: isActive || index != _previousIndex && !isActive
                    ? Offset(slideDx, 0)
                    : Offset.zero,
                child: _screens[index],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.97),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.09),
                  blurRadius: 24,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tab 0: Home
                _BouncingNavItem(
                  isSelected: _currentIndex == 0,
                  onTap: () => _onSelectTab(0),
                  child: Icon(
                    _currentIndex == 0
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                    size: 25,
                    color: _currentIndex == 0 ? activeBlue : inactiveGrey,
                  ),
                ),

                // Tab 1: Explore
                _BouncingNavItem(
                  isSelected: _currentIndex == 1,
                  onTap: () => _onSelectTab(1),
                  child: Icon(
                    _currentIndex == 1
                        ? Icons.explore_rounded
                        : Icons.explore_outlined,
                    size: 25,
                    color: _currentIndex == 1 ? activeBlue : inactiveGrey,
                  ),
                ),

                // Tab 2: Matkul (Book Lines)
                _BouncingNavItem(
                  isSelected: _currentIndex == 2,
                  onTap: () => _onSelectTab(2),
                  child: SvgPicture.asset(
                    'assets/images/bookmark.svg',
                    width: 23,
                    height: 23,
                    colorFilter: ColorFilter.mode(
                      _currentIndex == 2 ? activeBlue : inactiveGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                // Tab 3: Notifikasi & Chat (DM)
                _BouncingNavItem(
                  isSelected: _currentIndex == 3,
                  onTap: () => _onSelectTab(3),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        _currentIndex == 3
                            ? Icons.chat_bubble_rounded
                            : Icons.chat_bubble_outline_rounded,
                        size: 24,
                        color: _currentIndex == 3 ? activeBlue : inactiveGrey,
                      ),
                      Positioned(
                        top: -2,
                        right: -3,
                        child: AnimatedScale(
                          scale: hasUnread ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab 4: Profile
                _BouncingNavItem(
                  isSelected: _currentIndex == 4,
                  onTap: () => _onSelectTab(4),
                  child: Icon(
                    _currentIndex == 4
                        ? Icons.person_rounded
                        : Icons.person_outline_rounded,
                    size: 25,
                    color: _currentIndex == 4 ? activeBlue : inactiveGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Interactive Instagram-inspired tab item with tactile press-down scale
/// and spring pop-back animation when selected.
class _BouncingNavItem extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _BouncingNavItem({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  State<_BouncingNavItem> createState() => _BouncingNavItemState();
}

class _BouncingNavItemState extends State<_BouncingNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.82)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.82, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.18, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_bounceController);
  }

  @override
  void didUpdateWidget(covariant _BouncingNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isSelected && widget.isSelected) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        if (widget.isSelected) {
          _bounceController.forward(from: 0.0);
        }
      },
      onTap: widget.onTap,
      child: SizedBox(
        width: 56,
        height: 54,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
