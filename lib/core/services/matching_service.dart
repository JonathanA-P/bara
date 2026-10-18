import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class MatchingService {
  final SupabaseService _service;

  MatchingService({SupabaseService? service}) : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<List<Map<String, dynamic>>> getAvailableMentors() async {
    final client = _client;
    if (client == null) {
      // Mock fallback
      return [
        {
          'id': '1',
          'full_name': 'Farhan Maulana',
          'major': 'Teknik Informatika • Sem 7',
          'rating': 4.9,
          'review_count': 38,
          'hourly_rate': 25000,
          'skills': ['Algoritma Graf', 'Python', 'Competitive Programming'],
          'bio': 'Asisten Lab Pemrograman Dasar & Struktur Data. Terbiasa membimbing konsep rekursi dan DP.',
        },
      ];
    }

    final userId = _service.currentUserId;
    var query = client
        .from('mentor_profiles')
        .select('*, profiles(full_name, major, avatar_url, bio)')
        .eq('is_available', true);

    if (userId != null) {
      query = query.neq('user_id', userId);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> swipeMentor({
    required String mentorId,
    required bool isLike,
  }) async {
    final client = _client;
    final menteeId = _service.currentUserId;
    if (client == null || menteeId == null) return false;

    await client.from('mentor_swipes').upsert({
      'mentee_id': menteeId,
      'mentor_id': mentorId,
      'action': isLike ? 'like' : 'pass',
    });

    if (isLike) {
      // Create pending match
      final match = await client.from('mentorship_matches').insert({
        'mentee_id': menteeId,
        'mentor_id': mentorId,
        'status': 'pending_quiz',
      }).select().maybeSingle();

      return match != null;
    }

    return false;
  }
}
