import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class QuizService {
  final SupabaseService _service;

  QuizService({SupabaseService? service}) : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<List<Map<String, dynamic>>> getQuizQuestions({String? subject}) async {
    final client = _client;
    if (client == null) {
      // Mock questions for offline/demo mode
      return [
        {
          'id': '1',
          'question': 'Manakah struktur data yang menggunakan prinsip First-In, First-Out (FIFO)?',
          'options': ['Stack', 'Queue', 'Binary Tree', 'Priority Queue'],
          'correct_index': 1,
          'explanation': 'Queue mengikuti prinsip FIFO di mana elemen pertama yang masuk akan keluar terlebih dahulu.',
        },
        {
          'id': '2',
          'question': 'Algoritma traversal graf mana yang mengeksplorasi graf lapis demi lapis secara selevel?',
          'options': ['Depth-First Search (DFS)', 'Breadth-First Search (BFS)', 'Dijkstra', 'Floyd-Warshall'],
          'correct_index': 1,
          'explanation': 'BFS mengeksplorasi semua simpul tetangga pada level kedalaman saat ini sebelum pindah ke level berikutnya.',
        },
      ];
    }

    var query = client.from('competency_quizzes').select();
    if (subject != null && subject.isNotEmpty) {
      query = query.eq('subject', subject);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> submitQuizAttempt({
    String? matchId,
    required int score,
    String? diagnosticSummary,
  }) async {
    final client = _client;
    final menteeId = _service.currentUserId;
    if (client == null || menteeId == null) return;

    await client.from('quiz_attempts').insert({
      'match_id': matchId,
      'mentee_id': menteeId,
      'score': score,
      'diagnostic_summary': diagnosticSummary,
    });

    if (matchId != null) {
      // Update match status to accepted once quiz is finished
      await client.from('mentorship_matches').update({
        'status': 'accepted',
      }).eq('id', matchId);
    }
  }
}

