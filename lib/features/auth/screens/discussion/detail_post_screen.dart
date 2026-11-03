import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/app_data_controller.dart';
import '../course/course_detail_screen.dart';
import '../home/models/post_model.dart';
import '../profile/profile_screen.dart';

class DetailPostScreen extends StatefulWidget {
  final PostModel? post;

  const DetailPostScreen({
    super.key,
    this.post,
  });

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  final AppDataController _dataController = AppDataController.instance;
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();

  String? _replyingToCommentId;
  String? _replyingToAuthor;

  PostModel get _currentPost {
    final targetId = widget.post?.id;
    if (targetId != null) {
      final matched =
          _dataController.posts.where((p) => p.id == targetId).toList();
      if (matched.isNotEmpty) return matched.first;
      return widget.post!;
    }
    return _dataController.posts.first;
  }

  List<CommentModel> get _comments =>
      _dataController.getCommentsForPost(_currentPost.id);

  @override
  void initState() {
    super.initState();
    _dataController.addListener(_onDataUpdated);
    _replyController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dataController.loadRemoteCommentsForPost(_currentPost.id);
    });
  }

  void _onDataUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dataController.removeListener(_onDataUpdated);
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  void _showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF4C7BB8),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitComment() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    final parentId = _replyingToCommentId;
    final replyAuthor = _replyingToAuthor;

    _replyController.clear();
    setState(() {
      _replyingToCommentId = null;
      _replyingToAuthor = null;
    });
    _replyFocusNode.unfocus();

    await _dataController.addCommentToPost(
      postId: _currentPost.id,
      text: text,
      parentCommentId: parentId,
      replyToAuthor: replyAuthor,
    );
  }

  void _startReplyingToComment(String parentCommentId, String authorName) {
    HapticFeedback.selectionClick();
    setState(() {
      _replyingToCommentId = parentCommentId;
      _replyingToAuthor = authorName;
    });
    _replyFocusNode.requestFocus();
  }

  void _showReportDialog(String accusedName, String contextLabel) {
    String selectedCategory = 'Konten Tidak Pantas / Spam';
    final descController = TextEditingController();
    final categories = [
      'Konten Tidak Pantas / Spam',
      'Ujaran Kebencian / Perundungan',
      'Informasi Palsu (Hoaks Akademik)',
      'Pelanggaran Etika Kampus',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laporkan $contextLabel',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pilih alasan pelaporan untuk ditinjau moderator Hi!Gavi:',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return GestureDetector(
                        onTap: () =>
                            setDialogState(() => selectedCategory = cat),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                size: 18,
                                color: isSelected
                                    ? const Color(0xFF4C7BB8)
                                    : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cat,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      style: GoogleFonts.manrope(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'Keterangan tambahan (opsional)...',
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Batal',
                              style: GoogleFonts.manrope(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await _dataController.submitIncidentReport(
                                accusedName: accusedName,
                                category: selectedCategory,
                                description: descController.text.trim().isEmpty
                                    ? 'Laporan $contextLabel (${_currentPost.title})'
                                    : descController.text.trim(),
                              );
                              if (!mounted) return;
                              _showSuccessToast(
                                this.context,
                                'Laporan berhasil dikirim ke moderator',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Kirim Laporan',
                              style: GoogleFonts.manrope(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
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
      },
    );
  }

  void _showPostOptions(BuildContext context) {
    final post = _currentPost;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Opsi postingan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.authorName,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: Icons.menu_book_rounded,
                iconBg: const Color(0xFF5382C1),
                title: 'Lihat Mata Kuliah',
                subtitle: 'Informasi detail mata kuliah terkait',
                onTap: () {
                  Navigator.pop(sheetCtx);
                  final course = _dataController.courses.first;
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => CourseDetailScreen(
                        code: course.code,
                        title: course.title,
                        category: 'MATA KULIAH ${course.badgeText.toUpperCase()}',
                        sks: course.sks,
                        semester: course.semester,
                        rating: course.rating,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: post.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                iconBg: const Color(0xFF5382C1),
                title: post.isBookmarked
                    ? 'Hapus dari Simpanan'
                    : 'Simpan Postingan',
                subtitle: 'Akses cepat di tab Disimpan pada profilmu',
                onTap: () {
                  Navigator.pop(sheetCtx);
                  final saved = _dataController.toggleBookmarkPost(post.id);
                  _showSuccessToast(
                    context,
                    saved
                        ? 'Postingan disimpan ke Profil'
                        : 'Dihapus dari simpanan',
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: Icons.person_outline_rounded,
                iconBg: const Color(0xFF5382C1),
                title: 'Lihat Profil',
                subtitle: 'Kunjungi profil ${post.authorName}',
                onTap: () {
                  Navigator.pop(sheetCtx);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ProfileScreen(
                        peerName: post.authorName,
                        isStranger: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: Icons.flag_outlined,
                iconBg: Colors.orange.shade700,
                title: 'Laporkan',
                subtitle: 'Laporkan postingan ini',
                titleColor: Colors.orange.shade700,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _showReportDialog(post.authorName, 'Postingan');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    Color titleColor = const Color(0xFF1E293B),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comments = _comments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Detail Postingan',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainPost(),
                  const SizedBox(height: 24),
                  if (comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'Belum ada komentar. Jadilah yang pertama membalas!',
                          style: GoogleFonts.manrope(
                            fontSize: 12.5,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                  else
                    ...comments.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCommentItem(
                          comment: c,
                          parentCommentId: c.id,
                          hasReplies: c.replies.isNotEmpty,
                          replies: c.replies
                              .map(
                                (r) => _buildCommentItem(
                                  comment: r,
                                  parentCommentId: c.id,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  Widget _buildMainPost() {
    final post = _currentPost;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ProfileScreen(
                      peerName: post.authorName,
                      isStranger: true,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFCBD5E1),
                backgroundImage: AssetImage(post.authorAvatar),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ProfileScreen(
                        peerName: post.authorName,
                        isStranger: true,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• ${post.timeAgo}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      post.userRole ?? 'Mahasiswa FILKOM',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz_rounded, color: Colors.grey),
              onPressed: () => _showPostOptions(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (post.badges.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: post.badges
                .map(
                  (b) => _buildTag(
                    b.label,
                    b.backgroundColor,
                    textColor: b.textColor,
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 12),
        Text(
          post.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          post.content,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        if (post.imageAttachment != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              post.imageAttachment!,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (post.fileAttachment != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF0284C7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.fileAttachment!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _dataController.toggleLikePost(post.id);
              },
              child: Row(
                children: [
                  Icon(
                    post.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: post.isLiked ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${post.likesCount}',
                    style: TextStyle(
                      fontSize: 12,
                      color: post.isLiked ? Colors.red : Colors.grey,
                      fontWeight:
                          post.isLiked ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  '${post.commentsCount}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                final saved = _dataController.toggleBookmarkPost(post.id);
                _showSuccessToast(
                  context,
                  saved ? 'Disimpan ke Profil' : 'Dihapus dari simpanan',
                );
              },
              child: Icon(
                post.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 20,
                color: post.isBookmarked
                    ? const Color(0xFF5382C1)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentItem({
    required CommentModel comment,
    required String parentCommentId,
    bool hasReplies = false,
    List<Widget>? replies,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ProfileScreen(
                      peerName: comment.authorName,
                      isStranger: true,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFCBD5E1),
                backgroundImage: AssetImage(comment.authorAvatar),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ProfileScreen(
                                peerName: comment.authorName,
                                isStranger: true,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          comment.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      if (comment.replyTo != null) ...[
                        const Icon(
                          Icons.play_arrow_rounded,
                          size: 12,
                          color: Colors.grey,
                        ),
                        Text(
                          ' ${comment.replyTo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF5382C1),
                          ),
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showReportDialog(
                          comment.authorName,
                          'Komentar',
                        ),
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${comment.timeAgo} • ',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _startReplyingToComment(
                          parentCommentId,
                          comment.authorName,
                        ),
                        child: const Text(
                          'Balas',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5382C1),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _dataController.toggleLikeComment(
                            _currentPost.id,
                            comment.id,
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              comment.isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 14,
                              color:
                                  comment.isLiked ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${comment.likesCount}',
                              style: TextStyle(
                                fontSize: 11,
                                color: comment.isLiked
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (hasReplies && replies != null && replies.isNotEmpty)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 15),
                Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: replies.map((reply) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: reply,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTag(
    String text,
    Color bgColor, {
    Color textColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomInputBar() {
    final hasText = _replyController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_replyingToAuthor != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(
                      'Membalas @$_replyingToAuthor',
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF5382C1),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _replyingToCommentId = null;
                          _replyingToAuthor = null;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFCBD5E1),
                  backgroundImage: AssetImage(_dataController.currentAvatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF3F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _replyController,
                      focusNode: _replyFocusNode,
                      onSubmitted: (_) => _submitComment(),
                      decoration: InputDecoration(
                        hintText: _replyingToAuthor != null
                            ? 'Tulis balasan untuk $_replyingToAuthor...'
                            : 'Balas ${_currentPost.authorName}',
                        hintStyle:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                if (hasText) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _submitComment,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5382C1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
