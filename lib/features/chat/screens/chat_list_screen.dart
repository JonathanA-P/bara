import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/features/chat/screens/chat_room_screen.dart';
import 'package:bara/core/services/chat_service.dart';
import 'package:bara/core/services/supabase_service.dart';

class ChatConversation {
  final String id;
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String? activeSessionTag;

  ChatConversation({
    required this.id,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.activeSessionTag,
  });
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua', 'Mentor', 'Mentee', 'Sesi Aktif'];

  late List<ChatConversation> _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = [
      ChatConversation(
        id: '1',
        name: 'Farhan Maulana',
        role: 'Mentor • Teknik Informatika',
        lastMessage: 'Halo! Modul materi graf sudah saya unggah di ruang belajar ya.',
        time: '12:30',
        unreadCount: 2,
        isOnline: true,
        activeSessionTag: 'Live 1 Jam',
      ),
      ChatConversation(
        id: '2',
        name: 'Aleca Cantika',
        role: 'Mentor • Sistem Informasi',
        lastMessage: 'Sama-sama! Jangan ragu tanya jika ada kendala normalisasi DB.',
        time: 'Kemarin',
        unreadCount: 0,
        isOnline: true,
      ),
      ChatConversation(
        id: '3',
        name: 'Bagas Pratama',
        role: 'Mentor • Teknik Informatika',
        lastMessage: 'Besok kita review kisi-kisi UTS PBO lewat Google Meet atau Live Room?',
        time: '14 Okt',
        unreadCount: 1,
        isOnline: false,
      ),
      ChatConversation(
        id: '4',
        name: 'Rian Pratama',
        role: 'Mentee • Sistem Informasi',
        lastMessage: 'Terima kasih kak atas bimbingan query SQL tadi siang!',
        time: '12 Okt',
        unreadCount: 0,
        isOnline: false,
      ),
    ];
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final list = await ChatService().getConversations();
      if (list.isNotEmpty && mounted) {
        setState(() {
          _conversations = list.map((s) {
            final mentor = s['mentor'] as Map<String, dynamic>?;
            final mentee = s['mentee'] as Map<String, dynamic>?;
            final isMentor = s['mentor_id'] == SupabaseService.instance.currentUserId;
            final peer = isMentor ? mentee : mentor;
            final name = peer?['full_name'] as String? ?? 'Teman BARA';
            final role = peer?['major'] as String? ?? (isMentor ? 'Mentee' : 'Mentor');
            return ChatConversation(
              id: s['id']?.toString() ?? '1',
              name: name,
              role: role,
              lastMessage: 'Sesi mentoring aktif. Ketuk untuk membuka ruang bimbingan.',
              time: 'Aktif',
              unreadCount: 0,
              isOnline: true,
              activeSessionTag: 'Live Room',
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('[ChatList] Load error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatConversation> get _filteredConversations {
    final query = _searchController.text.trim().toLowerCase();
    final filter = _filters[_selectedFilterIndex];

    return _conversations.where((c) {
      if (filter == 'Mentor' && !c.role.contains('Mentor')) return false;
      if (filter == 'Mentee' && !c.role.contains('Mentee')) return false;
      if (filter == 'Sesi Aktif' && c.activeSessionTag == null) return false;

      if (query.isNotEmpty) {
        return c.name.toLowerCase().contains(query) ||
            c.lastMessage.toLowerCase().contains(query) ||
            c.role.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);
    final displayedList = _filteredConversations;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: textColorDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pesan & Bimbingan',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColorDark,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.manrope(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari percakapan atau mentor...',
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(Icons.search_rounded,
                            size: 20, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilterIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? buttonBlue
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? buttonBlue
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                _filters[index],
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Conversation List
            Expanded(
              child: displayedList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded,
                              size: 48, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada percakapan ditemukan',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: displayedList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final conv = displayedList[index];
                        return _buildConversationCard(conv);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationCard(ChatConversation conv) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(
              sessionId: conv.id,
              peerName: conv.name,
              peerRole: conv.role,
              sessionDuration: conv.activeSessionTag != null ? '45:10' : null,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFCBD5E1),
                backgroundImage:
                    AssetImage('assets/images/CloudArt_margin.png'),
              ),
              if (conv.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      conv.name,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColorDark,
                      ),
                    ),
                    Text(
                      conv.time,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  conv.role,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: buttonBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conv.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: conv.unreadCount > 0
                              ? textColorDark
                              : const Color(0xFF64748B),
                          fontWeight: conv.unreadCount > 0
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (conv.unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: const BoxDecoration(
                          color: buttonBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          conv.unreadCount.toString(),
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

