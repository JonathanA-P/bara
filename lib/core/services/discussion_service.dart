import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class DiscussionService {
  final SupabaseService _service;

  DiscussionService({SupabaseService? service}) : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<List<Map<String, dynamic>>> getDiscussions({String? tag}) async {
    final client = _client;
    if (client == null) {
      // Fallback demo discussions if client not initialized
      return [
        {
          'id': '1',
          'title': 'Bingung perbedaan implementasi Dijkstra vs A* Search di Python',
          'content': 'Halo teman-teman FILKOM, ada yang paham kapan A* lebih optimal daripada Dijkstra biasa untuk pathfinding labirin?',
          'tag': 'Struktur Data & Algoritma',
          'likes_count': 12,
          'replies_count': 4,
          'profiles': {'full_name': 'Ahmad Fauzi', 'major': 'Teknik Informatika'}
        },
      ];
    }

    var query = client.from('discussions').select('*, profiles(full_name, major, avatar_url)');
    if (tag != null && tag != 'Semua' && tag != 'For You') {
      query = query.eq('tag', tag);
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> createDiscussion({
    required String title,
    required String content,
    required String tag,
    int liveDurationMinutes = 0,
  }) async {
    final client = _client;
    final userId = _service.currentUserId;
    if (client == null || userId == null) return null;

    final response = await client.from('discussions').insert({
      'author_id': userId,
      'title': title,
      'content': content,
      'tag': tag,
      'live_duration_minutes': liveDurationMinutes,
    }).select().single();

    return response;
  }

  Future<void> toggleBookmark(String discussionId) async {
    final client = _client;
    final userId = _service.currentUserId;
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
        .select('*, profiles(full_name, major, avatar_url)')
        .eq('discussion_id', discussionId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addComment({
    required String discussionId,
    required String commentText,
  }) async {
    final client = _client;
    final userId = _service.currentUserId;
    if (client == null || userId == null) return;

    await client.from('discussion_comments').insert({
      'discussion_id': discussionId,
      'author_id': userId,
      'comment_text': commentText,
    });
  }
}

