import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class ChatService {
  final SupabaseService _service;

  ChatService({SupabaseService? service})
      : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<List<Map<String, dynamic>>> getConversations({
    String? userIdOverride,
  }) async {
    final client = _client;
    final userId = userIdOverride ?? _service.currentUserId;
    if (client == null || userId == null) return [];

    final response = await client
        .from('mentoring_sessions')
        .select(
          '*, mentor:mentor_id(id, full_name, email, major, avatar_url), mentee:mentee_id(id, full_name, email, major, avatar_url)',
        )
        .or('mentor_id.eq.$userId,mentee_id.eq.$userId')
        .order('started_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String?> getOrCreateSession({
    required String currentUserId,
    required String peerUserId,
    String topic = 'Direct Message',
  }) async {
    final client = _client;
    if (client == null) return null;

    final existing = await client
        .from('mentoring_sessions')
        .select('id')
        .or(
          'and(mentor_id.eq.$currentUserId,mentee_id.eq.$peerUserId),and(mentor_id.eq.$peerUserId,mentee_id.eq.$currentUserId)',
        )
        .limit(1);

    final list = List<Map<String, dynamic>>.from(existing);
    if (list.isNotEmpty && list.first['id'] != null) {
      return list.first['id'].toString();
    }

    final created = await client
        .from('mentoring_sessions')
        .insert({
          'mentor_id': peerUserId,
          'mentee_id': currentUserId,
          'topic': topic,
          'status': 'active',
        })
        .select('id')
        .single();

    return created['id']?.toString();
  }

  Future<List<Map<String, dynamic>>> getMessagesForSession(
    String sessionId,
  ) async {
    final client = _client;
    if (client == null) return [];

    final response = await client
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Stream<List<Map<String, dynamic>>> streamMessages(String sessionId) {
    final client = _client;
    if (client == null) {
      return const Stream.empty();
    }

    return client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
  }

  Future<Map<String, dynamic>?> sendMessage({
    required String sessionId,
    required String messageText,
    String? senderIdOverride,
    String? attachmentName,
    String? attachmentUrl,
  }) async {
    final client = _client;
    final senderId = senderIdOverride ?? _service.currentUserId;
    if (client == null || senderId == null) return null;

    final lower = messageText.toLowerCase();
    final bool flagged = lower.contains('bodoh') ||
        lower.contains('anjing') ||
        lower.contains('tolol');

    final inserted = await client
        .from('chat_messages')
        .insert({
          'session_id': sessionId,
          'sender_id': senderId,
          'message_text': messageText,
          'attachment_name': attachmentName,
          'attachment_url': attachmentUrl,
          'is_flagged_ai': flagged,
        })
        .select()
        .single();

    return inserted;
  }

  Future<List<Map<String, dynamic>>> getNotifications({
    String? userIdOverride,
  }) async {
    final client = _client;
    final userId = userIdOverride ?? _service.currentUserId;
    if (client == null || userId == null) return [];

    final response = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markAllNotificationsRead({String? userIdOverride}) async {
    final client = _client;
    final userId = userIdOverride ?? _service.currentUserId;
    if (client == null || userId == null) return;

    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId);
  }

  Future<void> createNotification({
    required String targetUserId,
    required String title,
    required String message,
    String type = 'social',
  }) async {
    final client = _client;
    if (client == null) return;

    await client.from('notifications').insert({
      'user_id': targetUserId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': false,
    });
  }
}
