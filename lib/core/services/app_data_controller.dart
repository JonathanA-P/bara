import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/auth/screens/home/models/post_model.dart';
import 'auth_service.dart';
import 'chat_service.dart';
import 'discussion_service.dart';
import 'report_service.dart';
import 'supabase_service.dart';

class CommentModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  final String? replyTo;
  int likesCount;
  bool isLiked;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.authorName,
    this.authorAvatar = 'assets/images/userLogo.png',
    required this.timeAgo,
    required this.content,
    this.replyTo,
    this.likesCount = 0,
    this.isLiked = false,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];
}

class UserProfileModel {
  String id;
  String name;
  String username;
  String email;
  String nim;
  String major;
  String bio;
  String avatar;
  int followersCount;
  int followingCount;
  bool isFollowedByMe;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.nim = '',
    required this.major,
    required this.bio,
    this.avatar = 'assets/images/userLogo.png',
    required this.followersCount,
    required this.followingCount,
    this.isFollowedByMe = false,
  });
}

class CourseReviewModel {
  final String username;
  final String comment;
  final double score;
  final List<String> tags;
  final String timeAgo;

  CourseReviewModel({
    required this.username,
    required this.comment,
    required this.score,
    this.tags = const [],
    this.timeAgo = 'Baru saja',
  });
}

class CourseModel {
  final String code;
  final String title;
  final String badgeText; // 'Wajib' or 'Pilihan'
  final String prodi;
  final int sks;
  final int semester;
  final String description;
  final String prerequisite;
  final List<Map<String, String>> rpsList;
  final List<Map<String, dynamic>> lecturers;
  final List<CourseReviewModel> reviews;
  double baseRatingSum;
  int baseRatingCount;

  CourseModel({
    required this.code,
    required this.title,
    required this.badgeText,
    required this.prodi,
    required this.sks,
    required this.semester,
    this.description =
        'Fondasi pemecahan masalah komputasional dengan algoritma yang efektif.',
    this.prerequisite = 'Dasar Pemrograman',
    required this.rpsList,
    required this.lecturers,
    required this.reviews,
    required this.baseRatingSum,
    required this.baseRatingCount,
  });

  int get totalRatings => baseRatingCount + reviews.length;

  double get rating {
    if (totalRatings == 0) return 0.0;
    final reviewsSum = reviews.fold<double>(0.0, (sum, r) => sum + r.score);
    final avg = (baseRatingSum + reviewsSum) / totalRatings;
    return double.parse(avg.toStringAsFixed(1));
  }
}

class AppDataController extends ChangeNotifier {
  static final AppDataController instance = AppDataController._internal();

  AppDataController._internal() {
    _seedCurriculumCatalog();
  }

  final AuthService _authService = AuthService();
  final DiscussionService _discussionService = DiscussionService();
  final ChatService _chatService = ChatService();
  final ReportService _reportService = ReportService();

  // --- CURRENT LOGGED IN USER (Synced from Supabase auth.users & public.profiles) ---
  String? currentUserId;
  String currentName = 'Mahasiswa FILKOM';
  String currentUsername = '@mahasiswa_ub';
  String currentEmail = '';
  String currentNim = '';
  String currentMajor = 'Teknik Informatika';
  String currentBio = 'Mahasiswa FILKOM Universitas Brawijaya';
  String currentAvatar = 'assets/images/userLogo.png';
  int currentFollowersCount = 0;

  // Pending registration data across multi-step signup screens
  String? pendingKtmImage;
  String pendingRegName = '';
  String pendingRegEmail = '';
  String pendingRegNim = '';
  String pendingRegProdi = 'Teknik Informatika';

  // --- LIVE DATABASE LISTS (No hardcoded fake accounts, posts, or chats) ---
  List<UserProfileModel> users = [];
  List<PostModel> posts = [];
  final Map<String, List<CommentModel>> _commentsByPostId = {};
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> chatRooms = [];
  final Map<String, List<Map<String, dynamic>>> _messagesByPeer = {};

  // --- ACADEMIC CURRICULUM CATALOG ---
  late List<CourseModel> courses;

  int get currentFollowingCount =>
      users.where((u) => u.isFollowedByMe).length;

  int get totalUnreadChatsCount => chatRooms.fold<int>(
        0,
        (sum, chat) => sum + ((chat['unreadCount'] as int?) ?? 0),
      );

  int get unreadNotificationsCount =>
      notifications.where((n) => n['isRead'] != true).length;

  String _formatTimeAgo(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Baru saja';
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return 'Baru saja';
    final diff = DateTime.now().toUtc().difference(dt.toUtc());
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    return '${diff.inDays}h lalu';
  }

  String _formatClockTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) {
      final now = TimeOfDay.now();
      return '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
    }
    final dt = DateTime.tryParse(isoString)?.toLocal();
    if (dt == null) return 'Baru saja';
    return '${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Syncs all live data from Supabase PostgreSQL (`profiles`, `mentor_swipes`, `discussions`, `bookmarks`, `mentoring_sessions`, `chat_messages`, `notifications`)
  Future<void> initialize() async {
    await syncWithSupabase();
  }

  Future<void> syncWithSupabase() async {
    try {
      await loadCurrentUserFromSupabase();
      await syncProfilesAndFollowsFromSupabase();
      await syncDiscussionsFromSupabase();
      await syncChatsFromSupabase();
      await syncNotificationsFromSupabase();
    } catch (e) {
      debugPrint('[AppDataController] Sync error: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await _authService.signOut();
    } catch (_) {}
    currentUserId = null;
    currentName = 'Mahasiswa FILKOM';
    currentUsername = '@mahasiswa_ub';
    currentEmail = '';
    currentNim = '';
    currentFollowersCount = 0;
    chatRooms = [];
    notifications = [];
    _messagesByPeer.clear();
    notifyListeners();
  }

  Future<void> registerNewAccount({
    required String fullName,
    required String username,
    required String email,
    required String nim,
    required String major,
    String? avatar,
  }) async {
    final cleanUsername = username.trim().replaceFirst('@', '');
    currentName = fullName.trim().isEmpty ? cleanUsername : fullName.trim();
    currentUsername =
        '@${cleanUsername.isEmpty ? "mahasiswa_ub" : cleanUsername}';
    currentEmail = email.trim();
    currentNim = nim.trim();
    currentMajor = major.trim().isEmpty ? 'Teknik Informatika' : major.trim();
    currentBio = 'Mahasiswa $currentMajor FILKOM Universitas Brawijaya';
    currentAvatar = avatar ?? pendingKtmImage ?? 'assets/images/userLogo.png';
    currentFollowersCount = 0;

    await syncWithSupabase();
    notifyListeners();
  }

  Future<void> loginWithCredentials({
    required String emailOrUsername,
  }) async {
    await syncWithSupabase();
  }

  Future<void> loadCurrentUserFromSupabase() async {
    final user = _authService.currentUser;
    if (user != null) {
      currentUserId = user.id;
      currentEmail = user.email ?? currentEmail;
      final meta = user.userMetadata;
      if (meta != null) {
        if ((meta['full_name'] as String?)?.isNotEmpty == true) {
          currentName = meta['full_name'] as String;
        }
        if ((meta['major'] as String?)?.isNotEmpty == true) {
          currentMajor = meta['major'] as String;
        }
        if ((meta['nim'] as String?)?.isNotEmpty == true) {
          currentNim = meta['nim'] as String;
        }
      }
      final prof = await _authService.getProfile(user.id);
      if (prof != null) {
        currentName = (prof['full_name'] as String?) ?? currentName;
        currentMajor = (prof['major'] as String?) ?? currentMajor;
        currentBio = (prof['bio'] as String?) ?? currentBio;
        currentNim = (prof['nim'] as String?) ?? currentNim;
        final avatarUrl = prof['avatar_url'] as String?;
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          currentAvatar = avatarUrl;
        }
      }
      final handle =
          currentName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      currentUsername = '@${handle.isEmpty ? "mahasiswa_ub" : handle}';
      notifyListeners();
    }
  }

  Future<void> syncProfilesAndFollowsFromSupabase() async {
    final client = SupabaseService.instance.client;
    if (client == null) return;

    try {
      final allProfiles = await _authService.getAllProfiles();
      final allSwipes = await _authService.getAllFollowSwipes();

      // If not authenticated via session yet but profiles exist in DB, match currentEmail
      if (currentUserId == null && currentEmail.isNotEmpty) {
        final matched = allProfiles.where(
          (p) =>
              (p['email'] as String? ?? '').toLowerCase() ==
              currentEmail.toLowerCase(),
        );
        if (matched.isNotEmpty) {
          final row = matched.first;
          currentUserId = row['id']?.toString();
          currentName = (row['full_name'] as String?) ?? currentName;
          currentMajor = (row['major'] as String?) ?? currentMajor;
          currentBio = (row['bio'] as String?) ?? currentBio;
          currentNim = (row['nim'] as String?) ?? currentNim;
        }
      }

      final myId = currentUserId ?? SupabaseService.instance.currentUserId;

      if (myId != null) {
        currentFollowersCount = allSwipes
            .where((s) => s['mentor_id']?.toString() == myId)
            .length;
      } else {
        currentFollowersCount = 0;
      }

      final List<UserProfileModel> loadedUsers = [];
      for (final row in allProfiles) {
        final uid = row['id']?.toString() ?? '';
        if (uid.isEmpty || uid == myId) continue;

        final fullName = (row['full_name'] as String?) ?? 'Mahasiswa FILKOM';
        final email = (row['email'] as String?) ?? '';
        final handle =
            fullName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        final followers = allSwipes
            .where((s) => s['mentor_id']?.toString() == uid)
            .length;
        final following = allSwipes
            .where((s) => s['mentee_id']?.toString() == uid)
            .length;
        final followedByMe = myId != null &&
            allSwipes.any(
              (s) =>
                  s['mentee_id']?.toString() == myId &&
                  s['mentor_id']?.toString() == uid,
            );

        loadedUsers.add(
          UserProfileModel(
            id: uid,
            name: fullName,
            username: '@${handle.isEmpty ? "mahasiswa" : handle}',
            email: email,
            nim: (row['nim'] as String?) ?? '',
            major: (row['major'] as String?) ?? 'Teknik Informatika',
            bio: (row['bio'] as String?) ??
                'Mahasiswa FILKOM Universitas Brawijaya',
            avatar: (row['avatar_url'] as String?) ??
                'assets/images/userLogo.png',
            followersCount: followers,
            followingCount: following,
            isFollowedByMe: followedByMe,
          ),
        );
      }

      users = loadedUsers;
      notifyListeners();
    } catch (e) {
      debugPrint('[AppDataController] syncProfilesAndFollowsFromSupabase: $e');
    }
  }

  Future<void> syncDiscussionsFromSupabase() async {
    final client = SupabaseService.instance.client;
    if (client == null) return;
    try {
      final myId = currentUserId ?? SupabaseService.instance.currentUserId;
      final remoteList = await _discussionService.getDiscussions();
      final bookmarkedIds =
          await _discussionService.getUserBookmarkedIds(userId: myId);

      final List<PostModel> loadedPosts = [];
      for (final row in remoteList) {
        final String id = row['id']?.toString() ?? '';
        if (id.isEmpty) continue;

        final profile = row['profiles'] as Map<String, dynamic>?;
        final authorName =
            profile?['full_name'] as String? ?? 'Mahasiswa FILKOM';
        final major = profile?['major'] as String? ?? 'Teknik Informatika';
        final avatarUrl =
            profile?['avatar_url'] as String? ?? 'assets/images/userLogo.png';
        final tag = row['tag'] as String? ?? 'DISKUSI KAMPUS';
        final isLuar = tag.toLowerCase().contains('luar') ||
            tag.toLowerCase().contains('umum') ||
            tag.toLowerCase().contains('meme') ||
            tag.toLowerCase().contains('sharing') ||
            tag.toLowerCase().contains('lomba');

        loadedPosts.add(
          PostModel(
            id: id,
            authorName: authorName,
            authorAvatar: avatarUrl,
            timeAgo: _formatTimeAgo(row['created_at']?.toString()),
            userRole: '$major • FILKOM UB',
            tab: isLuar ? PostCategoryTab.luarKelas : PostCategoryTab.kuliah,
            badges: [
              PostBadge(
                label: major.toUpperCase(),
                backgroundColor: const Color(0xFFF97316),
                textColor: Colors.white,
              ),
              PostBadge(
                label: tag.toUpperCase(),
                backgroundColor: const Color(0xFFE0F2FE),
                textColor: const Color(0xFF0284C7),
              ),
            ],
            title: row['title'] as String? ?? '',
            content: row['content'] as String? ?? '',
            likesCount: (row['likes_count'] as int?) ?? 0,
            commentsCount: (row['replies_count'] as int?) ?? 0,
            isBookmarked: bookmarkedIds.contains(id),
          ),
        );
      }
      posts = loadedPosts;
      notifyListeners();
    } catch (e) {
      debugPrint('[AppDataController] syncDiscussionsFromSupabase: $e');
    }
  }

  Future<void> syncChatsFromSupabase() async {
    final client = SupabaseService.instance.client;
    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    if (client == null || myId == null) return;
    try {
      final sessions = await _chatService.getConversations(userIdOverride: myId);
      final List<Map<String, dynamic>> loadedRooms = [];

      for (final s in sessions) {
        final sessionId = s['id']?.toString() ?? '';
        if (sessionId.isEmpty) continue;
        final mentor = s['mentor'] as Map<String, dynamic>?;
        final mentee = s['mentee'] as Map<String, dynamic>?;
        final isMentor = s['mentor_id']?.toString() == myId;
        final peer = isMentor ? mentee : mentor;
        final peerName = peer?['full_name'] as String?;
        final peerId = peer?['id']?.toString();
        if (peerName == null || peerName.isEmpty) continue;

        final rawMessages = await _chatService.getMessagesForSession(sessionId);
        final List<Map<String, dynamic>> mappedMessages = rawMessages.map((m) {
          final isMe = m['sender_id']?.toString() == myId;
          return <String, dynamic>{
            'id': m['id']?.toString() ?? '',
            'text': m['message_text'] as String? ?? '',
            'time': _formatClockTime(m['created_at']?.toString()),
            'isMe': isMe,
            'isFailed': false,
            'isLiked': false,
            'isNew': false,
            if (m['attachment_url'] != null)
              'imagePath': m['attachment_url'] as String,
            if (m['attachment_name'] != null)
              'attachmentName': m['attachment_name'] as String,
          };
        }).toList();

        _messagesByPeer[peerName] = mappedMessages;

        final lastMsgText = mappedMessages.isNotEmpty
            ? (mappedMessages.last['text'] as String)
            : (s['topic'] as String? ?? 'Mulai percakapan');
        final lastTime = mappedMessages.isNotEmpty
            ? (mappedMessages.last['time'] as String)
            : _formatTimeAgo(s['started_at']?.toString());

        loadedRooms.add({
          'id': sessionId,
          'sessionId': sessionId,
          'peerId': peerId,
          'name': peerName,
          'time': lastTime,
          'lastMessage': lastMsgText,
          'unreadCount': 0,
          'avatar':
              peer?['avatar_url'] as String? ?? 'assets/images/userLogo.png',
        });
      }

      chatRooms = loadedRooms;
      notifyListeners();
    } catch (e) {
      debugPrint('[AppDataController] syncChatsFromSupabase: $e');
    }
  }

  Future<void> syncNotificationsFromSupabase() async {
    final client = SupabaseService.instance.client;
    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    if (client == null || myId == null) return;
    try {
      final rows = await _chatService.getNotifications(userIdOverride: myId);
      notifications = rows.map((r) {
        return <String, dynamic>{
          'id': r['id']?.toString() ?? '',
          'title': r['title'] as String? ?? 'Notifikasi',
          'text': r['message'] as String? ?? '',
          'time': _formatTimeAgo(r['created_at']?.toString()),
          'isRead': (r['is_read'] as bool?) ?? false,
          'avatar': 'assets/images/userLogo.png',
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('[AppDataController] syncNotificationsFromSupabase: $e');
    }
  }

  // --- PROFILE & FOLLOW ACTIONS (Backed by public.profiles & public.mentor_swipes) ---
  Future<void> updateCurrentProfile({
    required String name,
    required String username,
    required String major,
    required String bio,
    String? avatar,
  }) async {
    await updateCurrentUserProfile(
      name: name,
      username: username,
      major: major,
      bio: bio,
      avatar: avatar,
    );
  }

  Future<void> updateCurrentUserProfile({
    required String name,
    required String username,
    required String major,
    required String bio,
    String? avatar,
  }) async {
    final oldName = currentName;
    currentName = name.trim().isEmpty ? currentName : name.trim();
    final cleanUsername = username.trim().replaceFirst('@', '');
    currentUsername =
        '@${cleanUsername.isEmpty ? "mahasiswa_ub" : cleanUsername}';
    currentMajor = major.trim().isEmpty ? currentMajor : major.trim();
    currentBio = bio.trim();
    if (avatar != null) currentAvatar = avatar;

    for (int i = 0; i < posts.length; i++) {
      if (posts[i].authorName == oldName) {
        posts[i] = posts[i].copyWith(
          authorName: currentName,
          userRole: '$currentMajor • FILKOM UB',
        );
      }
    }

    notifyListeners();

    try {
      await _authService.updateProfile(
        fullName: currentName,
        bio: currentBio,
        major: currentMajor,
        avatarUrl: currentAvatar,
      );
      await syncProfilesAndFollowsFromSupabase();
    } catch (_) {}
  }

  UserProfileModel getUserProfileByName(String name) {
    if (name.toLowerCase() == currentName.toLowerCase()) {
      return UserProfileModel(
        id: currentUserId ?? 'me',
        name: currentName,
        username: currentUsername,
        email: currentEmail,
        nim: currentNim,
        major: currentMajor,
        bio: currentBio,
        avatar: currentAvatar,
        followersCount: currentFollowersCount,
        followingCount: currentFollowingCount,
        isFollowedByMe: false,
      );
    }

    final existing = users.where(
      (u) => u.name.toLowerCase() == name.toLowerCase(),
    );
    if (existing.isNotEmpty) return existing.first;

    final handle = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return UserProfileModel(
      id: '',
      name: name,
      username: '@${handle.isEmpty ? "mahasiswa" : handle}',
      email: '',
      major: 'Teknik Informatika',
      bio: 'Mahasiswa FILKOM Universitas Brawijaya',
      followersCount: 0,
      followingCount: 0,
      isFollowedByMe: false,
    );
  }

  Future<void> toggleFollowUser(String name) async {
    final user = getUserProfileByName(name);
    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    if (user.id.isEmpty || user.id == 'me' || user.id == myId) return;

    user.isFollowedByMe = !user.isFollowedByMe;
    if (user.isFollowedByMe) {
      user.followersCount += 1;
    } else {
      if (user.followersCount > 0) user.followersCount -= 1;
    }
    notifyListeners();

    if (myId != null) {
      try {
        await _authService.setFollowInDb(
          followerId: myId,
          targetUserId: user.id,
          follow: user.isFollowedByMe,
        );
        if (user.isFollowedByMe) {
          await _chatService.createNotification(
            targetUserId: user.id,
            title: 'Pengikut Baru',
            message: '$currentName mulai mengikuti akun kamu.',
            type: 'follow',
          );
        }
      } catch (_) {}
    }
  }

  List<PostModel> getPostsForUser(String name) {
    return posts
        .where((p) => p.authorName.toLowerCase() == name.toLowerCase())
        .toList();
  }

  int getTotalPostsCountForUser(String name) {
    return getPostsForUser(name).length;
  }

  // --- POSTS, LIKES, BOOKMARKS & COMMENTS (Backed by public.discussions, public.discussion_comments, public.bookmarks) ---
  void toggleLikePost(String postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = posts[index];
    final newLiked = !post.isLiked;
    final newCount = newLiked ? post.likesCount + 1 : post.likesCount - 1;
    final safeCount = newCount < 0 ? 0 : newCount;
    posts[index] = post.copyWith(
      isLiked: newLiked,
      likesCount: safeCount,
    );
    notifyListeners();

    _discussionService.updateLikesCount(
      discussionId: postId,
      likesCount: safeCount,
    );
  }

  void setLikePost(String postId, bool liked) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = posts[index];
    if (post.isLiked == liked) return;
    final newCount = liked ? post.likesCount + 1 : post.likesCount - 1;
    final safeCount = newCount < 0 ? 0 : newCount;
    posts[index] = post.copyWith(
      isLiked: liked,
      likesCount: safeCount,
    );
    notifyListeners();

    _discussionService.updateLikesCount(
      discussionId: postId,
      likesCount: safeCount,
    );
  }

  bool toggleBookmarkPost(String postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;
    final post = posts[index];
    final newBookmarked = !post.isBookmarked;
    posts[index] = post.copyWith(isBookmarked: newBookmarked);
    notifyListeners();

    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    _discussionService.toggleBookmark(postId, userIdOverride: myId);
    return newBookmarked;
  }

  List<PostModel> get bookmarkedPosts =>
      posts.where((p) => p.isBookmarked).toList();

  Future<PostModel> createNewPost({
    required String title,
    required String content,
    required PostCategoryTab tab,
    required List<PostBadge> badges,
    required String tagLabel,
    String? imageAttachment,
    String? fileAttachment,
    String? fileSize,
  }) async {
    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    String postId = 'post_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final created = await _discussionService.createDiscussion(
        title: title,
        content: content,
        tag: tagLabel,
        authorIdOverride: myId,
      );
      if (created != null && created['id'] != null) {
        postId = created['id'].toString();
      }
    } catch (_) {}

    final newPost = PostModel(
      id: postId,
      authorName: currentName,
      authorAvatar: currentAvatar,
      timeAgo: 'Baru saja',
      userRole: '$currentMajor • FILKOM UB',
      tab: tab,
      badges: badges,
      title: title,
      content: content,
      imageAttachment: imageAttachment,
      fileAttachment: fileAttachment,
      fileSize: fileSize,
      likesCount: 0,
      commentsCount: 0,
    );

    posts.insert(0, newPost);
    _commentsByPostId[postId] = [];
    notifyListeners();
    return newPost;
  }

  List<CommentModel> getCommentsForPost(String postId) {
    return _commentsByPostId.putIfAbsent(postId, () => []);
  }

  Future<void> loadRemoteCommentsForPost(String postId) async {
    try {
      final remote = await _discussionService.getComments(postId);
      final List<CommentModel> loaded = [];
      for (final row in remote) {
        final cid = row['id']?.toString() ?? '';
        if (cid.isEmpty) continue;
        final prof = row['profiles'] as Map<String, dynamic>?;
        loaded.add(
          CommentModel(
            id: cid,
            authorName: prof?['full_name'] as String? ?? 'Mahasiswa FILKOM',
            authorAvatar:
                prof?['avatar_url'] as String? ?? 'assets/images/userLogo.png',
            timeAgo: _formatTimeAgo(row['created_at']?.toString()),
            content: row['comment_text'] as String? ?? '',
            likesCount: 0,
          ),
        );
      }
      _commentsByPostId[postId] = loaded;
      _recalculateCommentCount(postId);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> addCommentToPost({
    required String postId,
    required String text,
    String? parentCommentId,
    String? replyToAuthor,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final newComment = CommentModel(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      authorName: currentName,
      authorAvatar: currentAvatar,
      timeAgo: 'Baru saja',
      content: trimmed,
      replyTo: replyToAuthor,
      likesCount: 0,
    );

    final list = _commentsByPostId.putIfAbsent(postId, () => []);
    if (parentCommentId != null) {
      final parentIdx = list.indexWhere((c) => c.id == parentCommentId);
      if (parentIdx != -1) {
        list[parentIdx].replies.add(newComment);
      } else {
        list.add(newComment);
      }
    } else {
      list.add(newComment);
    }

    _recalculateCommentCount(postId);
    notifyListeners();

    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    final postIdx = posts.indexWhere((p) => p.id == postId);
    final updatedCount = postIdx != -1 ? posts[postIdx].commentsCount : null;

    try {
      await _discussionService.addComment(
        discussionId: postId,
        commentText:
            replyToAuthor != null ? '@$replyToAuthor $trimmed' : trimmed,
        authorIdOverride: myId,
        updatedRepliesCount: updatedCount,
      );
    } catch (_) {}
  }

  void toggleLikeComment(String postId, String commentId) {
    final list = _commentsByPostId[postId];
    if (list == null) return;
    for (final c in list) {
      if (c.id == commentId) {
        c.isLiked = !c.isLiked;
        c.likesCount += c.isLiked ? 1 : -1;
        notifyListeners();
        return;
      }
      for (final r in c.replies) {
        if (r.id == commentId) {
          r.isLiked = !r.isLiked;
          r.likesCount += r.isLiked ? 1 : -1;
          notifyListeners();
          return;
        }
      }
    }
  }

  void _recalculateCommentCount(String postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final list = _commentsByPostId[postId] ?? [];
    int total = 0;
    for (final c in list) {
      total += 1 + c.replies.length;
    }
    posts[index] = posts[index].copyWith(commentsCount: total);
  }

  // --- DIRECT MESSAGES (DM) & NOTIFICATIONS (Backed by public.mentoring_sessions & public.chat_messages) ---
  List<Map<String, dynamic>> getMessagesForPeer(String peerName) {
    return _messagesByPeer.putIfAbsent(peerName, () => []);
  }

  Future<void> loadMessagesForPeerFromDb(String peerName) async {
    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    if (myId == null) return;

    final peer = getUserProfileByName(peerName);
    if (peer.id.isEmpty || peer.id == 'me') return;

    try {
      final sessionId = await _chatService.getOrCreateSession(
        currentUserId: myId,
        peerUserId: peer.id,
      );
      if (sessionId == null) return;

      final rawMessages = await _chatService.getMessagesForSession(sessionId);
      _messagesByPeer[peerName] = rawMessages.map((m) {
        final isMe = m['sender_id']?.toString() == myId;
        return <String, dynamic>{
          'id': m['id']?.toString() ?? '',
          'text': m['message_text'] as String? ?? '',
          'time': _formatClockTime(m['created_at']?.toString()),
          'isMe': isMe,
          'isFailed': false,
          'isLiked': false,
          'isNew': false,
          if (m['attachment_url'] != null)
            'imagePath': m['attachment_url'] as String,
          if (m['attachment_name'] != null)
            'attachmentName': m['attachment_name'] as String,
        };
      }).toList();
      notifyListeners();
    } catch (_) {}
  }

  void markChatAsRead(String peerName) {
    final idx = chatRooms.indexWhere(
      (c) => (c['name'] as String).toLowerCase() == peerName.toLowerCase(),
    );
    if (idx != -1 && (chatRooms[idx]['unreadCount'] ?? 0) > 0) {
      chatRooms[idx]['unreadCount'] = 0;
      notifyListeners();
    }
  }

  Future<void> sendDirectMessage({
    required String peerName,
    required String text,
    String? imagePath,
    String? attachmentName,
    VoidCallback? onPeerAutoReply,
  }) async {
    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final timeStr = '$hour.$minute';

    final list = getMessagesForPeer(peerName);
    list.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'time': timeStr,
      'isMe': true,
      'isFailed': false,
      'isLiked': false,
      'isNew': true,
      if (imagePath != null) 'imagePath': imagePath,
      if (attachmentName != null) 'attachmentName': attachmentName,
    });

    final roomIdx = chatRooms.indexWhere(
      (c) => (c['name'] as String).toLowerCase() == peerName.toLowerCase(),
    );
    String? sessionId;
    if (roomIdx != -1) {
      final room = chatRooms.removeAt(roomIdx);
      sessionId = room['sessionId'] as String?;
      room['lastMessage'] = text;
      room['time'] = timeStr;
      room['unreadCount'] = 0;
      chatRooms.insert(0, room);
    } else {
      chatRooms.insert(0, {
        'id': 'chat_${DateTime.now().millisecondsSinceEpoch}',
        'name': peerName,
        'time': timeStr,
        'lastMessage': text,
        'unreadCount': 0,
        'avatar': 'assets/images/userLogo.png',
      });
    }
    notifyListeners();

    final myId = currentUserId ?? SupabaseService.instance.currentUserId;
    final peer = getUserProfileByName(peerName);
    if (myId != null && peer.id.isNotEmpty && peer.id != 'me') {
      try {
        sessionId ??= await _chatService.getOrCreateSession(
          currentUserId: myId,
          peerUserId: peer.id,
        );
        if (sessionId != null) {
          await _chatService.sendMessage(
            sessionId: sessionId,
            messageText: text,
            senderIdOverride: myId,
            attachmentName: attachmentName,
            attachmentUrl: imagePath,
          );
          await _chatService.createNotification(
            targetUserId: peer.id,
            title: 'Pesan Baru dari $currentName',
            message: text,
            type: 'chat',
          );
        }
      } catch (e) {
        debugPrint('[AppDataController] sendDirectMessage DB error: $e');
      }
    }
  }

  // --- INCIDENT / CONTENT REPORT (Connected to Jojo's ReportService) ---
  Future<bool> submitIncidentReport({
    required String accusedName,
    required String category,
    required String description,
  }) async {
    return await _reportService.submitReport(
      accusedName: accusedName,
      category: category,
      incidentDate: DateTime.now(),
      description: description,
    );
  }

  // --- COURSE RATINGS & ACADEMIC CATALOG ---
  CourseModel getCourseByCode(String code, {String? fallbackTitle}) {
    if (fallbackTitle != null && fallbackTitle.trim().isNotEmpty) {
      final cleanTitle =
          fallbackTitle.replaceAll('\n', ' ').trim().toLowerCase();
      final exactTitle = courses.where(
        (c) => c.title.replaceAll('\n', ' ').trim().toLowerCase() == cleanTitle,
      );
      if (exactTitle.isNotEmpty) return exactTitle.first;

      final partialTitle = courses.where(
        (c) =>
            c.title.replaceAll('\n', ' ').toLowerCase().contains(cleanTitle) ||
            cleanTitle.contains(c.title.replaceAll('\n', ' ').toLowerCase()),
      );
      if (partialTitle.isNotEmpty) return partialTitle.first;
    }

    final existing =
        courses.where((c) => c.code.toLowerCase() == code.toLowerCase());
    if (existing.isNotEmpty) return existing.first;

    final resolvedTitle =
        (fallbackTitle != null && fallbackTitle.trim().isNotEmpty)
            ? fallbackTitle.replaceAll('\n', ' ').trim()
            : 'Mata Kuliah $code';

    final generated = CourseModel(
      code: code.toUpperCase(),
      title: resolvedTitle,
      badgeText: 'Wajib',
      prodi: currentMajor,
      sks: 3,
      semester: 4,
      description:
          'Mempelajari konsep fundamental, metodologi, serta studi kasus aplikatif pada bidang $resolvedTitle.',
      prerequisite: 'Dasar Komputasi',
      baseRatingSum: 80.0,
      baseRatingCount: 20,
      rpsList: [
        {
          'title': 'Pengantar & Konsep Dasar $resolvedTitle',
          'subtitle': 'Minggu 1',
        },
        {'title': 'Metodologi & Pemodelan Sistem', 'subtitle': 'Minggu 2'},
        {'title': 'Analisis Kasus & Implementasi', 'subtitle': 'Minggu 3'},
        {'title': 'Evaluasi, Pengujian & Optimasi', 'subtitle': 'Minggu 4'},
      ],
      lecturers: [
        {'name': 'Tim Dosen Pengampu FILKOM UB', 'prob': 0.82, 'pct': '82%'},
      ],
      reviews: [],
    );
    courses.add(generated);
    return generated;
  }

  void addCourseReview({
    required String courseCode,
    required double score,
    required String comment,
    required List<String> tags,
  }) {
    final course = getCourseByCode(courseCode);
    final maskedName = _maskUsername(currentName);
    final reviewText = comment.trim().isNotEmpty
        ? comment.trim()
        : (tags.isNotEmpty
            ? 'Karakteristik matkul: ${tags.join(", ")}.'
            : 'Mata kuliah yang sangat bermanfaat untuk diikuti.');

    course.reviews.insert(
      0,
      CourseReviewModel(
        username: maskedName,
        comment: reviewText,
        score: double.parse(score.clamp(1.0, 5.0).toStringAsFixed(1)),
        tags: tags,
        timeAgo: 'Baru saja',
      ),
    );
    notifyListeners();
  }

  String _maskUsername(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.map((p) {
      if (p.isEmpty) return '';
      if (p.length == 1) return '${p[0]}***';
      return '${p[0]}${'*' * (p.length - 1)}';
    }).join(' ');
  }

  void _seedCurriculumCatalog() {
    courses = [
      CourseModel(
        code: 'IF2123',
        title: 'Algoritma & Pemrograman',
        badgeText: 'Wajib',
        prodi: 'Teknik Informatika',
        sks: 4,
        semester: 3,
        description:
            'Fondasi pemecahan masalah komputasional dengan algoritma yang efektif dan struktur kontrol terstruktur.',
        prerequisite: 'Dasar Pemrograman',
        baseRatingSum: 189.0,
        baseRatingCount: 45,
        rpsList: [
          {'title': 'Tipe Data & Variabel', 'subtitle': 'Minggu 1'},
          {'title': 'Ekspresi & Operator Komputasi', 'subtitle': 'Minggu 2'},
          {'title': 'Percabangan & Analisis Kasus', 'subtitle': 'Minggu 3'},
          {'title': 'Perulangan & Invarian Loop', 'subtitle': 'Minggu 4'},
          {'title': 'Fungsi, Prosedur & Rekursi', 'subtitle': 'Minggu 5'},
          {'title': 'Array, Matriks & Pencarian', 'subtitle': 'Minggu 6'},
          {'title': 'Algoritma Pengurutan (Sorting)', 'subtitle': 'Minggu 7'},
        ],
        lecturers: [
          {'name': 'Dr. Budi Santoso, S.Kom., M.T.', 'prob': 0.84, 'pct': '84%'},
          {'name': 'Nadia Prameswari, M.Cs.', 'prob': 0.68, 'pct': '68%'},
          {'name': 'Rizky Mahendra, M.Kom.', 'prob': 0.42, 'pct': '42%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'MA1101',
        title: 'Kalkulus Dasar',
        badgeText: 'Pilihan',
        prodi: 'Teknik Informatika',
        sks: 4,
        semester: 3,
        description:
            'Mempelajari limit, turunan, integral, serta deret tak hingga untuk pemodelan komputasi.',
        prerequisite: 'Matematika Komputasi',
        baseRatingSum: 134.4,
        baseRatingCount: 32,
        rpsList: [
          {
            'title': 'Sistem Bilangan Real & Pertidaksamaan',
            'subtitle': 'Minggu 1',
          },
          {
            'title': 'Fungsi & Grafik Fungsi Transenden',
            'subtitle': 'Minggu 2',
          },
          {'title': 'Limit & Kekontinuan Fungsi', 'subtitle': 'Minggu 3'},
          {'title': 'Turunan & Aturan Rantai', 'subtitle': 'Minggu 4'},
          {'title': 'Aplikasi Turunan & Optimasi', 'subtitle': 'Minggu 5'},
          {'title': 'Integral Tentu & Tak Tentu', 'subtitle': 'Minggu 6'},
        ],
        lecturers: [
          {'name': 'Prof. Hendra Wijaya, M.Si.', 'prob': 0.88, 'pct': '88%'},
          {'name': 'Dian Kusuma, S.Si., M.Mat.', 'prob': 0.61, 'pct': '61%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'SI2204',
        title: 'Basis Data',
        badgeText: 'Wajib',
        prodi: 'Sistem Informasi',
        sks: 4,
        semester: 3,
        description:
            'Perancangan basis data relasional, ERD, normalisasi (1NF-BCNF), serta query SQL tingkat lanjut.',
        prerequisite: 'Pengantar Sistem Informasi',
        baseRatingSum: 114.0,
        baseRatingCount: 30,
        rpsList: [
          {'title': 'Konsep Dasar & Arsitektur DBMS', 'subtitle': 'Minggu 1'},
          {'title': 'Entity-Relationship Diagram (ERD)', 'subtitle': 'Minggu 2'},
          {
            'title': 'Model Data Relasional & Pemetaan',
            'subtitle': 'Minggu 3',
          },
          {'title': 'DDL & DML pada SQL', 'subtitle': 'Minggu 4'},
          {'title': 'JOIN, Subquery & Agregasi', 'subtitle': 'Minggu 5'},
          {
            'title': 'Normalisasi 1NF, 2NF, 3NF & BCNF',
            'subtitle': 'Minggu 6',
          },
        ],
        lecturers: [
          {
            'name': 'Dr. Ratna Sari, S.Kom., M.MSI.',
            'prob': 0.81,
            'pct': '81%',
          },
          {'name': 'Bagus Setiawan, M.Kom.', 'prob': 0.55, 'pct': '55%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'IF2301',
        title: 'Struktur Data & Algoritma',
        badgeText: 'Wajib',
        prodi: 'Teknik Informatika',
        sks: 4,
        semester: 4,
        description:
            'Implementasi Linked List, Stack, Queue, Tree, Heap, Hash Table, dan algoritma Graf.',
        prerequisite: 'Algoritma & Pemrograman',
        baseRatingSum: 180.0,
        baseRatingCount: 40,
        rpsList: [
          {'title': 'Singly & Doubly Linked List', 'subtitle': 'Minggu 1'},
          {'title': 'Stack & Queue (LIFO / FIFO)', 'subtitle': 'Minggu 2'},
          {'title': 'Binary Tree & Binary Search Tree', 'subtitle': 'Minggu 3'},
          {'title': 'AVL Tree & Balanced Tree', 'subtitle': 'Minggu 4'},
          {'title': 'Graph Traversal (BFS & DFS)', 'subtitle': 'Minggu 5'},
          {'title': 'Shortest Path (Dijkstra & MST)', 'subtitle': 'Minggu 6'},
        ],
        lecturers: [
          {'name': 'Dr. Budi Santoso, S.Kom., M.T.', 'prob': 0.79, 'pct': '79%'},
          {'name': 'Fajar Nugroho, M.T.', 'prob': 0.64, 'pct': '64%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'TK2105',
        title: 'Arsitektur & Organisasi Komputer',
        badgeText: 'Wajib',
        prodi: 'Teknik Komputer',
        sks: 3,
        semester: 3,
        description:
            'Mempelajari set instruksi prosesor, pipelining, hierarki memori cache, dan sistem bus I/O.',
        prerequisite: 'Sistem Digital',
        baseRatingSum: 86.0,
        baseRatingCount: 20,
        rpsList: [
          {'title': 'Arsitektur Von Neumann & Harvard', 'subtitle': 'Minggu 1'},
          {
            'title': 'Representasi Data & Aritmetika ALU',
            'subtitle': 'Minggu 2',
          },
          {
            'title': 'Instruction Set Architecture (ISA)',
            'subtitle': 'Minggu 3',
          },
          {
            'title': 'Organisasi Memori Cache & Virtual',
            'subtitle': 'Minggu 4',
          },
        ],
        lecturers: [
          {'name': 'Ir. Surya Dharma, M.T.', 'prob': 0.85, 'pct': '85%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'TI3102',
        title: 'Keamanan Informasi & Jaringan',
        badgeText: 'Wajib',
        prodi: 'Teknologi Informasi',
        sks: 3,
        semester: 5,
        description:
            'Kriptografi modern, keamanan protokol jaringan, analisis kerentanan, dan pertahanan siber.',
        prerequisite: 'Jaringan Komputer',
        baseRatingSum: 102.5,
        baseRatingCount: 25,
        rpsList: [
          {'title': 'CIA Triad & Threat Modeling', 'subtitle': 'Minggu 1'},
          {
            'title': 'Kriptografi Simetris & Asimetris',
            'subtitle': 'Minggu 2',
          },
          {'title': 'Keamanan Web & OWASP Top 10', 'subtitle': 'Minggu 3'},
          {'title': 'Firewall, IDS/IPS & Zero Trust', 'subtitle': 'Minggu 4'},
        ],
        lecturers: [
          {'name': 'Dr. Eko Prasetyo, M.Kom.', 'prob': 0.77, 'pct': '77%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'PTI2201',
        title: 'Media Pembelajaran Interaktif',
        badgeText: 'Wajib',
        prodi: 'Pendidikan Teknologi Informasi',
        sks: 3,
        semester: 4,
        description:
            'Desain instruksional, pengembangan aplikasi edukasi interaktif, dan evaluasi pengalaman belajar.',
        prerequisite: 'Desain Grafis & Multimedia',
        baseRatingSum: 68.0,
        baseRatingCount: 20,
        rpsList: [
          {
            'title': 'Prinsip Multimedia Pembelajaran (Mayer)',
            'subtitle': 'Minggu 1',
          },
          {'title': 'Storyboarding & UI/UX Edukasi', 'subtitle': 'Minggu 2'},
          {'title': 'Pengembangan Modul Interaktif', 'subtitle': 'Minggu 3'},
          {
            'title': 'Usability Testing & Evaluasi Siswa',
            'subtitle': 'Minggu 4',
          },
        ],
        lecturers: [
          {'name': 'Dr. Siti Aminah, M.Pd.', 'prob': 0.90, 'pct': '90%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'IF3102',
        title: 'Kecerdasan Buatan',
        badgeText: 'Wajib',
        prodi: 'Teknik Informatika',
        sks: 3,
        semester: 5,
        description:
            'Mempelajari konsep agen cerdas, algoritma pencarian heuristik (A*, Minimax), representasi pengetahuan, dan pengantar Machine Learning.',
        prerequisite: 'Struktur Data & Algoritma',
        baseRatingSum: 151.2,
        baseRatingCount: 35,
        rpsList: [
          {
            'title': 'Pengantar AI & Intelligent Agents',
            'subtitle': 'Minggu 1',
          },
          {
            'title': 'Uninformed Search (BFS, DFS, UCS)',
            'subtitle': 'Minggu 2',
          },
          {
            'title': 'Heuristic Search (Greedy & A* Search)',
            'subtitle': 'Minggu 3',
          },
          {
            'title': 'Adversarial Search (Minimax & Alpha-Beta)',
            'subtitle': 'Minggu 4',
          },
          {
            'title': 'Constraint Satisfaction Problems (CSP)',
            'subtitle': 'Minggu 5',
          },
          {
            'title': 'Pengantar Supervised & Unsupervised Learning',
            'subtitle': 'Minggu 6',
          },
        ],
        lecturers: [
          {
            'name': 'Prof. Dr. Wayan Firdaus Mahmudy, M.T.',
            'prob': 0.89,
            'pct': '89%',
          },
          {
            'name': 'Dr. Eng. Novanto Yudistira, M.Sc.',
            'prob': 0.76,
            'pct': '76%',
          },
          {'name': 'Imam Cholissodin, S.Si., M.Kom.', 'prob': 0.62, 'pct': '62%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'SI2101',
        title: 'Manajemen Sistem Informasi',
        badgeText: 'Wajib',
        prodi: 'Sistem Informasi',
        sks: 3,
        semester: 3,
        description:
            'Strategi pengelolaan sistem informasi korporat, tata kelola TI (IT Governance), ERP, dan pengambilan keputusan berbasis data.',
        prerequisite: 'Pengantar Sistem Informasi',
        baseRatingSum: 109.2,
        baseRatingCount: 28,
        rpsList: [
          {
            'title': 'Peran Strategis SI dalam Organisasi Modern',
            'subtitle': 'Minggu 1',
          },
          {'title': 'Infrastruktur TI & Cloud Enterprise', 'subtitle': 'Minggu 2'},
          {
            'title': 'Enterprise Resource Planning (ERP & CRM)',
            'subtitle': 'Minggu 3',
          },
          {
            'title': 'Business Intelligence & Decision Support',
            'subtitle': 'Minggu 4',
          },
          {
            'title': 'Tata Kelola TI (COBIT & ITIL Framework)',
            'subtitle': 'Minggu 5',
          },
          {
            'title': 'Etika, Privasi Data & Keamanan Korporasi',
            'subtitle': 'Minggu 6',
          },
        ],
        lecturers: [
          {
            'name': 'Dr. Ir. Admaja Dwi Herlambang, M.Pd.',
            'prob': 0.86,
            'pct': '86%',
          },
          {'name': 'Issa Arwani, S.Kom., M.Sc.', 'prob': 0.71, 'pct': '71%'},
        ],
        reviews: [],
      ),
      CourseModel(
        code: 'IF2109',
        title: 'Sistem Operasi',
        badgeText: 'Wajib',
        prodi: 'Teknik Informatika',
        sks: 4,
        semester: 3,
        description:
            'Manajemen proses, penjadwalan CPU, sinkronisasi thread & deadlock, manajemen memori virtual, serta sistem berkas Linux.',
        prerequisite: 'Arsitektur & Organisasi Komputer',
        baseRatingSum: 137.6,
        baseRatingCount: 32,
        rpsList: [
          {'title': 'Arsitektur Kernel & System Calls', 'subtitle': 'Minggu 1'},
          {'title': 'Proses, Thread & Concurrency', 'subtitle': 'Minggu 2'},
          {
            'title': 'Algoritma Penjadwalan CPU (FCFS, SJF, RR)',
            'subtitle': 'Minggu 3',
          },
          {
            'title': 'Sinkronisasi Proses, Mutex & Deadlock',
            'subtitle': 'Minggu 4',
          },
          {
            'title': 'Manajemen Memori Paging & Virtual Memory',
            'subtitle': 'Minggu 5',
          },
          {'title': 'File System & Bash Scripting Linux', 'subtitle': 'Minggu 6'},
        ],
        lecturers: [
          {
            'name': 'Achmad Basuki, S.T., MMG., Ph.D.',
            'prob': 0.83,
            'pct': '83%',
          },
          {
            'name': 'Putra Pandu Adikara, S.Kom., M.Kom.',
            'prob': 0.69,
            'pct': '69%',
          },
        ],
        reviews: [],
      ),
    ];
  }
}
