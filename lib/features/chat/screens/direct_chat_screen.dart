import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'camera_screen.dart';

typedef ChatMessageMap = Map<String, dynamic>;

class DirectChatScreen extends StatefulWidget {
  final String peerName;
  final String lastSeen;
  final String avatarAsset;

  const DirectChatScreen({
    super.key,
    this.peerName = 'Alex Chan',
    this.lastSeen = 'Hari ini',
    this.avatarAsset = 'assets/images/userLogo.png',
  });

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearchingMessage = false;
  bool _showAttachmentMenu = false;

  // Master list pesan sesuai frame Figma "Mulai Pesan" & "Cari Pesan"
  final List<ChatMessageMap> _messages = [
    {
      'id': '1',
      'text': 'Selamat pagi, salam sejahtera',
      'time': '20.00',
      'isMe': true,
      'isFailed': false,
      'isLiked': false,
      'isNew': false,
    },
    {
      'id': '2',
      'text': 'Selamat pagi, salam sejahtera',
      'time': '20.00',
      'isMe': false,
      'isFailed': false,
      'isLiked': false,
      'isNew': false,
    },
    {
      'id': '3',
      'text': 'Selamat pagi, salam sejahtera',
      'time': '20.00',
      'isMe': true,
      'isFailed': true, // Mensimulasikan pesan gagal kirim dengan ikon merah reload
      'isLiked': false,
      'isNew': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();

    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'time': '$hour.$minute',
        'isMe': true,
        'isFailed': false,
        'isLiked': false,
        'isNew': true,
      });
      _showAttachmentMenu = false;
    });

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _toggleBubbleReaction(ChatMessageMap msg) {
    HapticFeedback.lightImpact();
    setState(() {
      msg['isLiked'] = !(msg['isLiked'] ?? false);
    });
  }

  // Dialog konfirmasi pesan gagal kirim (Figma: Kirim Ulang Pesan)
  void _showFailedMessageDialog(ChatMessageMap msg) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pesan kamu tidak terkirim.',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    // Tombol Hapus (Merah)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _messages.remove(msg);
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol Kirim Ulang (Outlined)
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            msg['isFailed'] = false;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Kirim ulang',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
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
      },
    );
  }

  void _openCamera() async {
    setState(() => _showAttachmentMenu = false);
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const CameraScreen()),
    );
    if (result != null) {
      final now = TimeOfDay.now();
      final hour = now.hour.toString().padLeft(2, '0');
      final minute = now.minute.toString().padLeft(2, '0');
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': '[Foto dikirim]',
          'time': '$hour.$minute',
          'isMe': true,
          'isFailed': false,
          'isLiked': false,
          'isNew': true,
        });
      });
    }
  }

  List<ChatMessageMap> get _displayedMessages {
    if (!_isSearchingMessage || _searchController.text.trim().isEmpty) {
      return _messages;
    }
    final query = _searchController.text.trim().toLowerCase();
    return _messages
        .where((m) => (m['text'] as String).toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _isSearchingMessage
              ? _buildSearchAppBar()
              : _buildDefaultAppBar(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_showAttachmentMenu) {
            setState(() => _showAttachmentMenu = false);
          }
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // 1. Wallpaper Pattern Background Maskot Bara (backgroundDM.png)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Image.asset(
                  'assets/images/backgroundDM.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),

            // 2. Daftar Pesan Chat & Bubble
            Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    children: [
                      // Badge Header Waktu (Hari ini)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 14),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8DA3BF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Hari ini',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // List Pesan Bubble
                      ..._displayedMessages.map((msg) => _buildChatBubble(msg)),
                    ],
                  ),
                ),

                // 3. Bottom Input Bar & Popover Attachment
                _buildBottomInputArea(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAppBar() {
    return AppBar(
      key: const ValueKey('default_appbar'),
      backgroundColor: Colors.white,
      elevation: 0.5,
      leadingWidth: 44,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF1E293B),
          size: 18,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFCBD5E1),
            backgroundImage: AssetImage(widget.avatarAsset),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.peerName,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  widget.lastSeen,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF1E293B), size: 22),
          onPressed: () {
            HapticFeedback.selectionClick();
            setState(() {
              _isSearchingMessage = true;
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Color(0xFF1E293B),
            size: 22,
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            _showChatRoomOptions();
          },
        ),
      ],
    );
  }

  Widget _buildSearchAppBar() {
    return AppBar(
      key: const ValueKey('search_appbar'),
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Container(
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: const Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: 'Cari pesan',
            hintStyle: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E293B), size: 20),
          onPressed: () {
            setState(() {
              _isSearchingMessage = false;
              _searchController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessageMap msg) {
    final bool isMe = msg['isMe'] ?? false;
    final bool isFailed = msg['isFailed'] ?? false;
    final bool isLiked = msg['isLiked'] ?? false;
    final bool isNew = msg['isNew'] ?? false;

    Widget bubbleRow = Padding(
      padding: EdgeInsets.only(bottom: isLiked ? 20 : 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onDoubleTap: () => _toggleBubbleReaction(msg),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                  decoration: BoxDecoration(
                    color:
                        isMe ? const Color(0xFF4C7BB8) : const Color(0xFF8C9BAE),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        msg['text'],
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg['time'],
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Instagram DM Double-Tap ❤️ Reaction Badge
                Positioned(
                  bottom: -10,
                  right: isMe ? null : 8,
                  left: isMe ? 8 : null,
                  child: AnimatedScale(
                    scale: isLiked ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.elasticOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 13,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isFailed) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showFailedMessageDialog(msg),
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.refresh, color: Colors.white, size: 14),
              ),
            ),
          ],
        ],
      ),
    );

    if (!isNew) return bubbleRow;

    // Smooth pop-in entrance animation for newly sent messages
    return TweenAnimationBuilder<double>(
      key: ValueKey(msg['id']),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      onEnd: () {
        msg['isNew'] = false;
      },
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: Transform.scale(
              scale: 0.92 + (0.08 * value),
              alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
              child: child,
            ),
          ),
        );
      },
      child: bubbleRow,
    );
  }

  Widget _buildBottomInputArea() {
    final bool hasText = _messageController.text.trim().isNotEmpty;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Popover Menu Attachment (+) with Smooth Scale & Opacity Animation
            Positioned(
              bottom: 56,
              left: 0,
              child: IgnorePointer(
                ignoring: !_showAttachmentMenu,
                child: AnimatedScale(
                  scale: _showAttachmentMenu ? 1.0 : 0.75,
                  alignment: Alignment.bottomLeft,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    opacity: _showAttachmentMenu ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 160),
                    child: Container(
                      width: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B9BB4),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          _buildAttachmentOption(
                            Icons.description_outlined,
                            'Dokumen',
                            () {
                              setState(() => _showAttachmentMenu = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pilih dokumen'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const Divider(color: Colors.white24, height: 1),
                          _buildAttachmentOption(
                            Icons.photo_library_outlined,
                            'Foto & Video',
                            () {
                              setState(() => _showAttachmentMenu = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pilih foto & video'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const Divider(color: Colors.white24, height: 1),
                          _buildAttachmentOption(
                            Icons.camera_alt_outlined,
                            'Kamera',
                            _openCamera,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Baris Input Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7DEE9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: AnimatedRotation(
                            turns: _showAttachmentMenu ? 0.125 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF475569),
                              size: 22,
                            ),
                          ),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _showAttachmentMenu = !_showAttachmentMenu;
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: const Color(0xFF1E293B),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan',
                              hintStyle: GoogleFonts.manrope(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF475569),
                            size: 22,
                          ),
                          onPressed: _openCamera,
                        ),
                      ],
                    ),
                  ),
                ),

                // Smooth Animated Send Button Appearance
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: hasText
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.7, end: 1.0),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: GestureDetector(
                              onTap: _sendMessage,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4C7BB8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatRoomOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                title: Text(
                  'Hapus Pesan',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEF4444),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Riwayat pesan dihapus'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.report_outlined, color: Color(0xFFEF4444)),
                title: Text(
                  'Laporkan Pesan',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEF4444),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Laporan pesan terkirim'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
