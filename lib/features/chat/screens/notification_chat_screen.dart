import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Data Notifikasi (Figma)
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'name': 'Alex Chen',
      'date': '08/10/26',
      'message': 'Menyukai postingan kamu.',
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '2',
      'name': 'Alex Chen',
      'date': '08/10/26',
      'message': 'Mulai mengikuti kamu.',
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '3',
      'name': 'Alex Chen',
      'date': '08/10/26',
      'message': 'Postingan kamu dihapus karena melanggar.',
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '4',
      'name': 'Alex Chen',
      'date': '08/10/26',
      'message': 'Menyukai postingan kamu.',
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '5',
      'name': 'Alex Chen',
      'date': '08/10/26',
      'message': 'Menyukai postingan kamu.',
      'avatar': 'assets/images/userLogo.png',
    },
  ];

  // Data Pesan (Figma)
  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': 'Alex Chen',
      'time': 'Hari ini',
      'lastMessage': 'Udah makan belum?',
      'unreadCount': 0,
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '2',
      'name': 'Alex Chen',
      'time': 'Kemarin',
      'lastMessage': 'Hayuk mabar bro',
      'unreadCount': 2,
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '3',
      'name': 'Alex Chen',
      'time': '08/10/26',
      'lastMessage': 'Ok',
      'unreadCount': 0,
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '4',
      'name': 'Alex Chen',
      'time': '08/10/26',
      'lastMessage': 'Terima kasih atas perhatiannya.',
      'unreadCount': 99,
      'avatar': 'assets/images/userLogo.png',
    },
    {
      'id': '5',
      'name': 'Alex Chen',
      'time': '08/10/26',
      'lastMessage': 'Gokil brok',
      'unreadCount': 0,
      'avatar': 'assets/images/userLogo.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  void _showNotificationOptions(
    TapDownDetails details,
    int index,
  ) async {
    final position = details.globalPosition;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Laporan terkirim'),
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

            // 2. TABS: NOTIFIKASI | PESAN (WITH UNDERLINE INDICATOR)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Tab Notifikasi
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Notifikasi',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: _selectedTab == 0
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: _selectedTab == 0
                                    ? activeBlue
                                    : inactiveGrey,
                              ),
                            ),
                          ),
                          Container(
                            height: 2.5,
                            color: _selectedTab == 0
                                ? activeBlue
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab Pesan
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Pesan',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: _selectedTab == 1
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: _selectedTab == 1
                                    ? activeBlue
                                    : inactiveGrey,
                              ),
                            ),
                          ),
                          Container(
                            height: 2.5,
                            color: _selectedTab == 1
                                ? activeBlue
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. TAB CONTENT LISTVIEW
            Expanded(
              child: _selectedTab == 0
                  ? _buildNotificationList()
                  : _buildChatList(),
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        TapDownDetails? tapDownDetails;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
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
        );
      },
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final int unreadCount = chat['unreadCount'] ?? 0;
        TapDownDetails? tapDownDetails;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
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
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Trailing: Badge Unread Or 3-dots
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: unreadCount > 9 ? 6 : 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B), // Orange badge like Figma
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount >= 99 ? '99+' : unreadCount.toString(),
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  GestureDetector(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
