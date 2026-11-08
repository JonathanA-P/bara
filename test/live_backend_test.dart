import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bara/core/services/supabase_service.dart';
import 'package:bara/core/services/auth_service.dart';
import 'package:bara/core/services/discussion_service.dart';
import 'package:bara/core/services/matching_service.dart';
import 'package:bara/core/services/quiz_service.dart';
import 'package:bara/core/services/report_service.dart';
import 'package:bara/core/services/chat_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  SharedPreferences.setMockInitialValues({});

  group('Live Supabase Backend & Database Integration Tests', () {
    setUpAll(() async {
      await dotenv.load(fileName: '.env');
      await SupabaseService.instance.initialize();
    });

    test('SupabaseService connects to live backend instance successfully', () {
      final service = SupabaseService.instance;
      expect(service.isInitialized, isTrue);
      expect(service.client, isNotNull);
      expect(dotenv.env['SUPABASE_URL'], contains('ehhlmggnmzckdgihcrkg'));
    });

    test('AuthService correctly rejects invalid credentials via live Auth API', () async {
      final auth = AuthService();
      expect(
        () async => await auth.signIn(
          email: 'unregistered_dummy_user_99@student.ub.ac.id',
          password: 'wrong_password_123',
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('DiscussionService queries discussions table from live Supabase', () async {
      final discussionService = DiscussionService();
      final discussions = await discussionService.getDiscussions();

      expect(discussions, isA<List<Map<String, dynamic>>>());
      if (discussions.isNotEmpty) {
        final first = discussions.first;
        expect(first.containsKey('title'), isTrue);
        expect(first.containsKey('content'), isTrue);
      }
    });

    test('MatchingService queries available mentors table from live Supabase', () async {
      final matchingService = MatchingService();
      final mentors = await matchingService.getAvailableMentors();

      expect(mentors, isA<List<Map<String, dynamic>>>());
      expect(mentors.isNotEmpty, isTrue);
      expect(mentors.first['full_name'], isNotNull);
    });

    test('QuizService queries competency quizzes table from live Supabase', () async {
      final quizService = QuizService();
      final questions = await quizService.getQuizQuestions();

      expect(questions, isA<List<Map<String, dynamic>>>());
      expect(questions.isNotEmpty, isTrue);
      expect(questions.first['options'], isA<List>());
    });

    test('ChatService queries active chat messages table safely', () async {
      final chatService = ChatService();
      final conversations = await chatService.getConversations();

      expect(conversations, isA<List<Map<String, dynamic>>>());
    });

    test('ReportService successfully processes report validation', () async {
      final reportService = ReportService();
      final success = await reportService.submitReport(
        accusedName: 'Test Report Target',
        category: 'Ketidakhadiran',
        incidentDate: DateTime.now(),
        description: 'Verifikasi pengujian integrasi live backend BARA.',
      );
      expect(success, isTrue);
    });

    test('Supabase profiles table query returns active records', () async {
      final client = SupabaseService.instance.client;
      expect(client, isNotNull);

      final profiles = await client!.from('profiles').select().limit(5);
      expect(profiles, isA<List>());
      expect(profiles.isNotEmpty, isTrue);
      final first = profiles.first;
      expect(first.containsKey('email'), isTrue);
      expect(first.containsKey('full_name'), isTrue);
      expect(first['email'], contains('@'));
    });
  });
}
