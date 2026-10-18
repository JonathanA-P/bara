import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/features/report/screens/report_incident_screen.dart';
import 'package:bara/core/services/chat_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final String? attachmentName;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.attachmentName,
  });
}

class ChatRoomScreen extends StatefulWidget {
  final String? sessionId;
  final String peerName;
  final String peerRole;
  final String? sessionDuration;

  const ChatRoomScreen({
    super.key,
    this.sessionId,
    this.peerName = 'Farhan Maulana',
    this.peerRole = 'Mentor • Teknik Informatika',
    this.sessionDuration = '45:10',
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      ChatMessage(
        id: '1',
        text: 'Halo! Sesi bimbingan 1-on-1 dimulai ya.',
        isMe: false,
        time: '19:00',
      ),
      ChatMessage(
        id: '2',
        text: 'Halo kak Farhan, terima kasih sudah menerima jadwal bimbingan.',
        isMe: true,
        time: '19:01',
      ),
      ChatMessage(
        id: '3',
        text:
            'Sama-sama! Sudah saya cek hasil kuis validasi kamu, skor 100%. Kita fokus bahas implementasi Dijkstra di graf berbobot ya.',
        isMe: false,
        time: '19:02',
      ),
      ChatMessage(
        id: '4',
        text:
            'Berikut rangkuman struktur data adjacency list dan implementasi dasar yang bisa kamu pelajari:',
        isMe: false,
        time: '19:03',
        attachmentName: 'Dijkstra_Graph_Implementation.dart',
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMe: true,
          time: '$hour:$minute',
        ),
      );
    });

    _messageController.clear();

    try {
      ChatService().sendMessage(
        sessionId: widget.sessionId ?? 'default-session',
        messageText: text,
      );
    } catch (_) {}

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _endSessionPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Akhiri Sesi Bimbingan?',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'Sesi akan ditutup dan arsip live chat ini akan otomatis tersimpan di riwayat bimbingan Anda.',
          style: GoogleFonts.manrope(
            fontSize: 12,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close chat room
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sesi selesai. Percakapan tersimpan di Bookmark!',
                    style: GoogleFonts.manrope(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5382C1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Akhiri & Simpan',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: textColorDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFCBD5E1),
              backgroundImage: AssetImage('assets/images/CloudArt_margin.png'),
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
                      color: textColorDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.peerRole,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (widget.sessionDuration != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 13, color: Color(0xFF059669)),
                  const SizedBox(width: 4),
                  Text(
                    widget.sessionDuration!,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: textColorDark),
            onSelected: (val) {
              if (val == 'end') {
                _endSessionPrompt();
              } else if (val == 'report') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportIncidentScreen(
                      reportedUserName: widget.peerName,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'end',
                child: Text(
                  'Akhiri Sesi Bimbingan',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5382C1),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Text(
                  'Laporkan Masalah Sesi',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg, buttonBlue, textColorDark);
                },
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded,
                        color: Color(0xFF64748B), size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Pilih file lampiran materi / code snippet',
                            style: GoogleFonts.manrope(fontSize: 12),
                          ),
                          duration: const Duration(milliseconds: 1000),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        onSubmitted: (_) => _sendMessage(),
                        style: GoogleFonts.manrope(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Tulis pesan atau pertanyaan...',
                          hintStyle: GoogleFonts.manrope(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: buttonBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
      ChatMessage msg, Color buttonBlue, Color textColorDark) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? buttonBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: msg.isMe ? Colors.white : textColorDark,
                height: 1.35,
              ),
            ),

            if (msg.attachmentName != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: msg.isMe
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code_rounded,
                      size: 16,
                      color: msg.isMe ? Colors.white : const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        msg.attachmentName!,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: msg.isMe
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 4),
            Text(
              msg.time,
              style: GoogleFonts.manrope(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: msg.isMe
                    ? Colors.white.withValues(alpha: 0.75)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

