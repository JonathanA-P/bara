import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class DiscussionService {
  final SupabaseService _service;

  DiscussionService({SupabaseService? service})
      : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<List<Map<String, dynamic>>> getDiscussions({String? tag}) async {
    final client = _client;
    if (client == null) return [];

    var query = client
        .from('discussions')
        .select('*, profiles(id, full_name, email, major, avatar_url)');
    if (tag != null && tag != 'Semua' && tag != 'For You') {
      query = query.eq('tag', tag);
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Set<String>> getUserBookmarkedIds({String? userId}) async {
    final client = _client;
    final uid = userId ?? _service.currentUserId;
    if (client == null || uid == null) return {};

    final response = await client
        .from('bookmarks')
        .select('discussion_id')
        .eq('user_id', uid);

    return List<Map<String, dynamic>>.from(response)
        .map((r) => r['discussion_id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  Future<Map<String, dynamic>?> createDiscussion({
    required String title,
    required String content,
    required String tag,
    String? authorIdOverride,
    int liveDurationMinutes = 0,
  }) async {
    final client = _client;
    final userId = authorIdOverride ?? _service.currentUserId;
    if (client == null || userId == null) return null;

    final response = await client
        .from('discussions')
        .insert({
          'author_id': userId,
          'title': title,
          'content': content,
          'tag': tag,
          'live_duration_minutes': liveDurationMinutes,
        })
        .select('*, profiles(id, full_name, email, major, avatar_url)')
        .single();

    return response;
  }

  Future<void> updateLikesCount({
    required String discussionId,
    required int likesCount,
  }) async {
    final client = _client;
    if (client == null) return;

    await client
        .from('discussions')
        .update({'likes_count': likesCount})
        .eq('id', discussionId);
  }

  Future<void> toggleBookmark(String discussionId, {String? userIdOverride}) async {
    final client = _client;
    final userId = userIdOverride ?? _service.currentUserId;
    if (client == null || userId == null) return;

    final exists = await client
        .from('bookmarks')
        .select()
        .eq('user_id', userId)
        .eq('discussion_id', discussionId)
        .maybeSingle();

    if (exists != null) {
      await client
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('discussion_id', discussionId);
    } else {
      await client.from('bookmarks').insert({
        'user_id': userId,
        'discussion_id': discussionId,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String discussionId) async {
    final client = _client;
    if (client == null) return [];

    final response = await client
        .from('discussion_comments')
        .select('*, profiles(id, full_name, major, avatar_url)')
        .eq('discussion_id', discussionId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> addComment({
    required String discussionId,
    required String commentText,
    String? authorIdOverride,
    int? updatedRepliesCount,
  }) async {
    final client = _client;
    final userId = authorIdOverride ?? _service.currentUserId;
    if (client == null || userId == null) return null;

    final inserted = await client
        .from('discussion_comments')
        .insert({
          'discussion_id': discussionId,
          'author_id': userId,
          'comment_text': commentText,
        })
        .select('*, profiles(id, full_name, major, avatar_url)')
        .single();

    if (updatedRepliesCount != null) {
      await client
          .from('discussions')
          .update({'replies_count': updatedRepliesCount})
          .eq('id', discussionId);
    }

    return inserted;
  }
}
