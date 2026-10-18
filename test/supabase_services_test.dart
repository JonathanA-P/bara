import 'package:flutter_test/flutter_test.dart';
import 'package:bara/core/services/supabase_service.dart';
import 'package:bara/core/services/auth_service.dart';
import 'package:bara/core/services/discussion_service.dart';
import 'package:bara/core/services/matching_service.dart';
import 'package:bara/core/services/quiz_service.dart';
import 'package:bara/core/services/report_service.dart';

void main() {
  group('Supabase Services Tests', () {
    test('SupabaseService handles missing credentials gracefully', () async {
      final service = SupabaseService.instance;
      expect(service.isInitialized, isFalse);
      expect(service.client, isNull);
    });

    test('AuthService returns null safely when unauthenticated or offline', () async {
      final authService = AuthService();
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);

      final res = await authService.signIn(email: 'test@student.ub.ac.id', password: 'password123');
      expect(res, isNull);
    });

    test('DiscussionService returns fallback discussions when offline', () async {
      final discService = DiscussionService();
      final discussions = await discService.getDiscussions();
      expect(discussions, isNotEmpty);
      expect(discussions.first['title'], contains('Dijkstra'));
    });

    test('MatchingService returns available mentors when offline', () async {
      final matchService = MatchingService();
      final mentors = await matchService.getAvailableMentors();
      expect(mentors, isNotEmpty);
      expect(mentors.first['full_name'], equals('Farhan Maulana'));
    });

    test('QuizService returns competency questions when offline', () async {
      final quizService = QuizService();
      final questions = await quizService.getQuizQuestions();
      expect(questions, isNotEmpty);
      expect(questions.first['options'], isA<List>());
    });

    test('ReportService successfully accepts reports offline', () async {
      final reportService = ReportService();
      final success = await reportService.submitReport(
        accusedName: 'Oknum',
        category: 'Ketidakhadiran',
        incidentDate: DateTime.now(),
        description: 'Mentor tidak hadir pada jadwal yang disepakati.',
      );
      expect(success, isTrue);
    });
  });
}

