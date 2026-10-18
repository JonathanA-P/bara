import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/features/auth/screens/discussion/detail_post_screen.dart';

enum NotificationType { mentoring, discussion, system }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua', 'Bimbingan', 'Diskusi', 'Sistem'];

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Permintaan Bimbingan Diterima!',
        message:
            'Farhan Maulana menyetujui sesi bimbingan 1-on-1: "Struktur Data & Graf" untuk besok pukul 19.00 WIB.',
        timeAgo: '10m lalu',
        type: NotificationType.mentoring,
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Diskusi Live Sedang Berlangsung',
        message:
            'Aleca Cantika memulai live room: "Normalisasi Database & SQL Lanjut". Gabung sekarang!',
        timeAgo: '45m lalu',
        type: NotificationType.discussion,
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Catatanmu Mendapat 25 Upvote!',
        message:
            'Banyak mahasiswa mengapresiasi catatan studimu: "Complete Guide to Advanced Graph Algorithms".',
        timeAgo: '2j lalu',
        type: NotificationType.discussion,
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        title: 'Pengingat Kuis Kompetensi',
        message:
            'Selesaikan kuis pemahaman materi dasar sebelum sesi bimbingan dimulai untuk validasi awal.',
        timeAgo: '5j lalu',
        type: NotificationType.mentoring,
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'Verifikasi Akun Kampus Berhasil',
        message:
            'Identitas mahasiswa FILKOM UB (@student.ub.ac.id) telah terverifikasi aman.',
        timeAgo: '1 hari lalu',
        type: NotificationType.system,
        isRead: true,
      ),
    ];
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilterIndex == 0) return _notifications;
    final selectedFilter = _filters[_selectedFilterIndex];

    return _notifications.where((n) {
      if (selectedFilter == 'Bimbingan') {
        return n.type == NotificationType.mentoring;
      } else if (selectedFilter == 'Diskusi') {
        return n.type == NotificationType.discussion;
      } else if (selectedFilter == 'Sistem') {
        return n.type == NotificationType.system;
      }
      return true;
    }).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Semua notifikasi ditandai telah dibaca',
          style: GoogleFonts.manrope(fontSize: 12),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);
    final displayedList = _filteredNotifications;

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
          'Notifikasi',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColorDark,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Tandai dibaca',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: buttonBlue,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
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
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? buttonBlue : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
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
            ),

            const SizedBox(height: 8),

            // Notifications List
            Expanded(
              child: displayedList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 48, color: const Color(0xFF94A3B8)),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada notifikasi',
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
                        final item = displayedList[index];
                        return _buildNotificationCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (item.type) {
      case NotificationType.mentoring:
        icon = Icons.school_rounded;
        iconColor = const Color(0xFF2563EB);
        iconBg = const Color(0xFFEFF6FF);
        break;
      case NotificationType.discussion:
        icon = Icons.chat_bubble_rounded;
        iconColor = const Color(0xFF059669);
        iconBg = const Color(0xFFECFDF5);
        break;
      case NotificationType.system:
        icon = Icons.shield_rounded;
        iconColor = const Color(0xFFD97706);
        iconBg = const Color(0xFFFEF3C7);
        break;
    }

    return GestureDetector(
      onTap: () {
        setState(() => item.isRead = true);
        if (item.type == NotificationType.discussion) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetailPostScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead
              ? Colors.white
              : const Color(0xFFF0F6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead
                ? const Color(0xFFE2E8F0)
                : const Color(0xFFBFDBFE),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: const Color(0xFF475569),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.timeAgo,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
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
}

