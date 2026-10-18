import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class ChatService {
  final SupabaseService _service;

  ChatService({SupabaseService? service}) : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<List<Map<String, dynamic>>> getConversations() async {
    final client = _client;
    final userId = _service.currentUserId;
    if (client == null || userId == null) return [];

    final response = await client
        .from('mentoring_sessions')
        .select('*, mentor:mentor_id(full_name, major, avatar_url), mentee:mentee_id(full_name, major, avatar_url)')
        .or('mentor_id.eq.$userId,mentee_id.eq.$userId')
        .order('started_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Realtime stream of messages in a mentoring session
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

  Future<void> sendMessage({
    required String sessionId,
    required String messageText,
    String? attachmentName,
    String? attachmentUrl,
  }) async {
    final client = _client;
    final senderId = _service.currentUserId;
    if (client == null || senderId == null) return;

    // Basic client-side sensitive content filter flag
    final lower = messageText.toLowerCase();
    final bool flagged = lower.contains('bodoh') || lower.contains('anjing') || lower.contains('tolol');

    await client.from('chat_messages').insert({
      'session_id': sessionId,
      'sender_id': senderId,
      'message_text': messageText,
      'attachment_name': attachmentName,
      'attachment_url': attachmentUrl,
      'is_flagged_ai': flagged,
    });
  }
}

