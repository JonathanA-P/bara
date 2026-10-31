import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/app_data_controller.dart';
import '../../auth/screens/discussion/detail_post_screen.dart';
import '../../auth/screens/profile/profile_screen.dart';
import 'direct_chat_screen.dart';

class NotificationChatScreen extends StatefulWidget {
  final int initialTabIndex; // 0 for Notifikasi, 1 for Pesan

  const NotificationChatScreen({
    super.key,
    this.initialTabIndex = 1, // Default ke tab Pesan seperti di Figma
  });

  @override
  State<NotificationChatScreen> createState() => _NotificationChatScreenState();
}

class _NotificationChatScreenState extends State<NotificationChatScreen> {
  late int _selectedTab; // 0: Notifikasi, 1: Pesan
  late final PageController _pageController;
  final AppDataController _dataController = AppDataController.instance;

  List<Map<String, dynamic>> get _notifications =>
      _dataController.notifications;

  List<Map<String, dynamic>> get _chats {
    final rooms = List<Map<String, dynamic>>.from(_dataController.chatRooms);
    for (final user in _dataController.users) {
      final exists = rooms.any(
        (r) =>
            (r['name'] as String? ?? '').toLowerCase() ==
            user.name.toLowerCase(),
      );
      if (!exists) {
        rooms.add({
          'id': user.id,
          'peerId': user.id,
          'name': user.name,
          'time': user.major,
          'lastMessage': 'Ketuk untuk mulai percakapan',
          'unreadCount': 0,
          'avatar': user.avatar,
        });
      }
    }
    return rooms;
  }

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
    _pageController = PageController(initialPage: _selectedTab);
    _dataController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dataController.removeListener(_onDataChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_selectedTab == index) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedTab = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await _dataController.syncWithSupabase();
    if (mounted) setState(() {});
  }

  void _showNotificationOptions(
    TapDownDetails details,
    int index,
  ) async {
    final position = details.globalPosition;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final notif = _notifications[index];

    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 140,
        position.dy,
        position.dx,
        position.dy + 100,
      ),
      color: const Color(0xFFCBD5E1),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem<String>(
          value: 'hapus',
          height: 34,
          child: Text(
            'Hapus notifikasi',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'lapor',
          height: 34,
          child: Text(
            'Laporkan notifikasi',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );

    if (value == 'hapus' && mounted) {
      HapticFeedback.mediumImpact();
      setState(() {
        _notifications.removeAt(index);
      });
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Notifikasi dihapus'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (value == 'lapor' && mounted) {
      await _dataController.submitIncidentReport(
        accusedName: notif['name'] ?? 'Pengguna',
        category: 'Notifikasi Mencurigakan',
        description: notif['message'] ?? '',
      );
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Laporan terkirim ke moderator'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showChatOptions(
    TapDownDetails details,
    int index,
  ) async {
    final position = details.globalPosition;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final chat = _chats[index];

    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 120,
        position.dy,
        position.dx,
        position.dy + 100,
      ),
      color: const Color(0xFFCBD5E1),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem<String>(
          value: 'hapus',
          height: 34,
          child: Text(
            'Hapus pesan',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'lapor',
          height: 34,
          child: Text(
            'Laporkan pesan',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );

    if (value == 'hapus' && mounted) {
      HapticFeedback.mediumImpact();
      setState(() {
        _chats.removeAt(index);
      });
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Pesan dihapus'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (value == 'lapor' && mounted) {
      await _dataController.submitIncidentReport(
        accusedName: chat['name'] ?? 'Pengguna',
        category: 'Pelanggaran Pesan',
        description: chat['lastMessage'] ?? '',
      );
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Laporan pesan terkirim'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF4C7BB8);
    const Color inactiveGrey = Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 1. TOP CENTER LOGO & TITLE (logohigavi.png + HiGavi)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logohigavi.png',
                  width: 38,
                  height: 38,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/hiGavi.png',
                    width: 38,
                    height: 38,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'HiGavi',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: activeBlue,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. TABS: NOTIFIKASI | PESAN (WITH SMOOTH SLIDING UNDERLINE INDICATOR)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Tab Notifikasi
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _switchTab(0),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: _selectedTab == 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: _selectedTab == 0
                                      ? activeBlue
                                      : inactiveGrey,
                                ),
                                child: const Text('Notifikasi'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Tab Pesan
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _switchTab(1),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: _selectedTab == 1
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: _selectedTab == 1
                                      ? activeBlue
                                      : inactiveGrey,
                                ),
                                child: const Text('Pesan'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Smooth Sliding Underline Indicator
                  SizedBox(
                    height: 2.5,
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      alignment: _selectedTab == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          height: 2.5,
                          color: activeBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. SWIPEABLE TAB CONTENT (INSTAGRAM DM-STYLE PAGEVIEW)
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (_selectedTab != index) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedTab = index);
                  }
                },
                children: [
                  _buildNotificationList(),
                  _buildChatList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: LIST NOTIFIKASI ---
  Widget _buildNotificationList() {
    if (_notifications.isEmpty) {
      return Center(
        child: Text(
          'Belum ada notifikasi',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF4C7BB8),
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          TapDownDetails? tapDownDetails;

          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                notif['isRead'] = true;
              });
              final targetPostId = notif['targetPostId'] as String?;
              if (targetPostId != null) {
                final matched = _dataController.posts
                    .where((p) => p.id == targetPostId)
                    .toList();
                if (matched.isNotEmpty) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => DetailPostScreen(post: matched.first),
                    ),
                  );
                  return;
                }
              }
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ProfileScreen(
                    peerName: notif['name'] ?? 'Alex Chen',
                    isStranger: true,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFCBD5E1),
                    backgroundImage: AssetImage(notif['avatar']),
                  ),
                  const SizedBox(width: 12),

                  // Title and Message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: notif['name'],
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              TextSpan(
                                text: ' • ${notif['date']}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notif['message'],
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: notif['isRead'] == true
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: notif['isRead'] == true
                                ? const Color(0xFF64748B)
                                : const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // 3-dots action button
                  GestureDetector(
                    onTapDown: (details) => tapDownDetails = details,
                    onTap: () {
                      if (tapDownDetails != null) {
                        _showNotificationOptions(tapDownDetails!, index);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- TAB 2: LIST PESAN ---
  Widget _buildChatList() {
    if (_chats.isEmpty) {
      return Center(
        child: Text(
          'Belum ada obrolan',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF4C7BB8),
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          final int unreadCount = chat['unreadCount'] ?? 0;
          TapDownDetails? tapDownDetails;

          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              _dataController.markChatAsRead(chat['name']);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => DirectChatScreen(
                    peerName: chat['name'],
                    lastSeen: chat['time'],
                    avatarAsset: chat['avatar'],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFCBD5E1),
                    backgroundImage: AssetImage(chat['avatar']),
                  ),
                  const SizedBox(width: 12),

                  // Name & Last message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: chat['name'],
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              TextSpan(
                                text: ' • ${chat['time']}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          chat['lastMessage'],
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: unreadCount > 0
                                ? const Color(0xFF1E293B)
                                : const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Trailing: Badge Unread Or 3-dots (with smooth AnimatedSwitcher)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: unreadCount > 0
                        ? Container(
                            key: ValueKey('badge_$unreadCount'),
                            padding: EdgeInsets.symmetric(
                              horizontal: unreadCount > 9 ? 6 : 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFF59E0B), // Orange badge like Figma
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unreadCount >= 99
                                  ? '99+'
                                  : unreadCount.toString(),
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GestureDetector(
                            key: const ValueKey('more_dots'),
                            onTapDown: (details) => tapDownDetails = details,
                            onTap: () {
                              if (tapDownDetails != null) {
                                _showChatOptions(tapDownDetails!, index);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.more_horiz_rounded,
                                color: Color(0xFF94A3B8),
                                size: 20,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
