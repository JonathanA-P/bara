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
    final liveList = List<Map<String, dynamic>>.from(response);
    if (liveList.isNotEmpty) {
      return liveList.map((m) {
        final prof = m['profiles'] as Map<String, dynamic>?;
        return {
          'id': m['id'] ?? m['user_id'],
          'user_id': m['user_id'],
          'full_name': prof?['full_name'] ?? 'Mentor FILKOM',
          'major': prof?['major'] ?? 'Teknik Informatika',
          'rating': (m['rating'] as num?)?.toDouble() ?? 5.0,
          'review_count': m['total_reviews'] ?? 0,
          'hourly_rate': m['hourly_rate'] ?? 25000,
          'skills': m['skills'] ?? ['Pemrograman Dasar', 'Struktur Data'],
          'bio': prof?['bio'] ?? m['headline'] ?? '',
        };
      }).toList();
    }

    return [
      {
        'id': '1',
        'full_name': 'Farhan Maulana',
        'major': 'Teknik Informatika • Sem 7',
        'rating': 4.9,
        'review_count': 38,
        'hourly_rate': 25000,
        'skills': ['Algoritma Graf', 'Python', 'Competitive Programming'],
        'bio':
            'Asisten Lab Pemrograman Dasar & Struktur Data. Terbiasa membimbing konsep rekursi dan DP.',
      },
      {
        'id': '2',
        'full_name': 'Sarah Safitri',
        'major': 'Sistem Informasi • Sem 5',
        'rating': 4.85,
        'review_count': 24,
        'hourly_rate': 20000,
        'skills': ['UI/UX Figma', 'Database SQL', 'Desain Produk'],
        'bio':
            'Juara 2 UI/UX Design Nasional. Suka sharing best practice Figma prototyping dan analisis kebutuhan.',
      },
    ];
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
