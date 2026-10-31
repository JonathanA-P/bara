import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/app_data_controller.dart';
import '../../../chat/screens/direct_chat_screen.dart';
import '../discussion/detail_post_screen.dart';
import '../home/models/post_model.dart';
import '../login/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool? isStranger;
  final String? peerName;

  const ProfileScreen({
    super.key,
    this.isStranger = false,
    this.peerName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppDataController _dataController = AppDataController.instance;
  int _selectedSubTab = 0; // 0: Postingan, 1: Disimpan (own profile only)

  bool get _isViewingStranger =>
      widget.isStranger == true &&
      widget.peerName != null &&
      widget.peerName!.toLowerCase() !=
          _dataController.currentName.toLowerCase();

  UserProfileModel get _displayedProfile {
    if (_isViewingStranger) {
      return _dataController.getUserProfileByName(widget.peerName!);
    }
    return _dataController.getUserProfileByName(_dataController.currentName);
  }

  @override
  void initState() {
    super.initState();
    _dataController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dataController.removeListener(_onDataChanged);
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Red Logout Icon inside light red box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFDC2626),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Keluar?',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  'Yakin untuk melanjutkan? Kamu akan keluar dari akun.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Batal
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Keluar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await _dataController.logoutUser();
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Keluar',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
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
  }

  void _openEditProfile() async {
    final profile = _displayedProfile;
    await Navigator.push<Map<String, String>>(
      context,
      CupertinoPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: profile.name,
          initialUsername: profile.username.replaceFirst('@', ''),
          initialMajor: profile.major,
          initialBio: profile.bio,
        ),
      ),
    );
  }

  void _showFollowListSheet({required bool showFollowingOnly}) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final list = showFollowingOnly
                ? _dataController.users
                : _dataController.users;

            return SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.68,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        showFollowingOnly ? 'Mengikuti' : 'Pengikut',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFE2E8F0), height: 1),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(
                            color: Color(0xFFF1F5F9),
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final u = list[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                Navigator.push(
                                  this.context,
                                  CupertinoPageRoute(
                                    builder: (_) => ProfileScreen(
                                      peerName: u.name,
                                      isStranger: true,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFFCBD5E1),
                                backgroundImage: AssetImage(u.avatar),
                              ),
                              title: Text(
                                u.name,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              subtitle: Text(
                                '${u.username} • ${u.major}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    _dataController.toggleFollowUser(u.name);
                                    setModalState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: u.isFollowedByMe
                                        ? const Color(0xFFEFF4FA)
                                        : const Color(0xFF4C7BB8),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: u.isFollowedByMe
                                          ? const BorderSide(
                                              color: Color(0xFFCBD5E1),
                                            )
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Text(
                                    u.isFollowedByMe ? 'Mengikuti' : 'Ikuti',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: u.isFollowedByMe
                                          ? const Color(0xFF1E293B)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color textColorDark = Color(0xFF1E293B);
    final profile = _displayedProfile;
    final userPosts = _dataController.getPostsForUser(profile.name);
    final savedPosts = _dataController.bookmarkedPosts;
    final activePosts =
        (!_isViewingStranger && _selectedSubTab == 1) ? savedPosts : userPosts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. HEADER BANNER & OVERLAPPING AVATAR
              SizedBox(
                height: 180,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Landscape Banner
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/CloudArt_margin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Back Button when viewing another user's profile
                    if (_isViewingStranger)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: textColorDark,
                            ),
                          ),
                        ),
                      ),

                    // Action Buttons (Own Profile: Edit Profil + Logout | Stranger: Ikuti + Pesan)
                    Positioned(
                      right: 0,
                      top: 148,
                      child: _isViewingStranger
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    _dataController
                                        .toggleFollowUser(profile.name);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: profile.isFollowedByMe
                                        ? Colors.white
                                        : const Color(0xFF4C7BB8),
                                    elevation: 0,
                                    side: profile.isFollowedByMe
                                        ? const BorderSide(
                                            color: Color(0xFFCBD5E1),
                                            width: 1.2,
                                          )
                                        : BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 7,
                                    ),
                                  ),
                                  child: Text(
                                    profile.isFollowedByMe
                                        ? 'Mengikuti'
                                        : 'Ikuti',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: profile.isFollowedByMe
                                          ? textColorDark
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => DirectChatScreen(
                                          peerName: profile.name,
                                          avatarAsset: profile.avatar,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 15,
                                    color: textColorDark,
                                  ),
                                  label: Text(
                                    'Pesan',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: textColorDark,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                // Edit Profil Button
                                OutlinedButton(
                                  onPressed: _openEditProfile,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 7,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Edit Profil',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: textColorDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Logout Icon Button
                                GestureDetector(
                                  onTap: _showLogoutDialog,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.logout_rounded,
                                      color: Color(0xFFDC2626),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    // Avatar Overlapping Banner
                    Positioned(
                      left: 14,
                      top: 88,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFCBD5E1),
                          backgroundImage: AssetImage(profile.avatar),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. NAME & USERNAME
              Text(
                profile.name,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textColorDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profile.username,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 14),

              // 3. DYNAMIC STATS ROW (Total Post, Followers, Following)
              Row(
                children: [
                  _buildStatItem(
                    '${userPosts.length}',
                    'Total Post',
                  ),
                  const SizedBox(width: 24),
                  _buildStatItem(
                    '${profile.followersCount}',
                    'Followers',
                    onTap: () => _showFollowListSheet(showFollowingOnly: false),
                  ),
                  const SizedBox(width: 24),
                  _buildStatItem(
                    '${profile.followingCount}',
                    'Following',
                    onTap: () => _showFollowListSheet(showFollowingOnly: true),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 4. MAJOR (Program Studi)
              Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    profile.major,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // 5. BIO
              Text(
                profile.bio,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF475569),
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 16),

              // Sub-tabs on own profile (Postingan | Disimpan)
              if (!_isViewingStranger)
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedSubTab = 0);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedSubTab == 0
                                      ? const Color(0xFF4C7BB8)
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Postingan (${userPosts.length})',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: _selectedSubTab == 0
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: _selectedSubTab == 0
                                      ? const Color(0xFF4C7BB8)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedSubTab = 1);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedSubTab == 1
                                      ? const Color(0xFF4C7BB8)
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Disimpan (${savedPosts.length})',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: _selectedSubTab == 1
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: _selectedSubTab == 1
                                      ? const Color(0xFF4C7BB8)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Divider(color: Color(0xFFE2E8F0), thickness: 1),

              const SizedBox(height: 12),

              // 6. DYNAMIC FEED OF USER POSTS OR SAVED POSTS
              if (activePosts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      _selectedSubTab == 1
                          ? 'Belum ada diskusi yang disimpan'
                          : 'Belum ada postingan diskusi',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                )
              else
                ...activePosts.map(
                  (post) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildDynamicPostCard(post),
                  ),
                ),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicPostCard(PostModel post) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => DetailPostScreen(post: post),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Header Row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(post.authorAvatar),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: post.authorName,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            TextSpan(
                              text: ' • ${post.timeAgo}',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        post.userRole ?? 'Mahasiswa FILKOM',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _dataController.toggleBookmarkPost(post.id);
                  },
                  child: Icon(
                    post.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: post.isBookmarked
                        ? const Color(0xFF4C7BB8)
                        : const Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Badges
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.badges.map((b) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: b.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    b.label,
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: b.textColor,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              post.title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
                height: 1.35,
              ),
            ),

            if (post.content.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                post.content,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
            ],

            const SizedBox(height: 10),

            // Bottom like / comment stats
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
                        size: 16,
                        color: post.isLiked
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likesCount}',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: post.isLiked
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline_rounded,
                    size: 15, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(
                  '${post.commentsCount}',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(color: Color(0xFFF1F5F9), thickness: 1),
          ],
        ),
      ),
    );
  }
}
