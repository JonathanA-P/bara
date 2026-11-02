import 'package:flutter_test/flutter_test.dart';
import 'package:bara/core/services/discussion_service.dart';
import 'package:bara/core/services/matching_service.dart';
import 'package:bara/core/services/chat_service.dart';

void main() {
  group('Supabase Push & Pull Integration Tests', () {
    test('DiscussionService pulls discussion feed successfully', () async {
      final discussionService = DiscussionService();
      final discussions = await discussionService.getDiscussions();

      expect(discussions, isA<List<Map<String, dynamic>>>());
      expect(discussions.isNotEmpty, isTrue);
      final first = discussions.first;
      expect(first.containsKey('title'), isTrue);
      expect(first.containsKey('content'), isTrue);
    });

    test('DiscussionService filters discussions by tag', () async {
      final discussionService = DiscussionService();
      final discussions = await discussionService.getDiscussions(tag: 'Struktur Data & Algoritma');

      expect(discussions, isA<List<Map<String, dynamic>>>());
      expect(discussions.isNotEmpty, isTrue);
    });

    test('MatchingService pulls available mentors', () async {
      final matchingService = MatchingService();
      final mentors = await matchingService.getAvailableMentors();

      expect(mentors, isA<List<Map<String, dynamic>>>());
      expect(mentors.isNotEmpty, isTrue);
      expect(mentors.first['full_name'], isNotNull);
    });

    test('DiscussionService bookmarks pull returns list safely', () async {
      final discussionService = DiscussionService();
      final bookmarks = await discussionService.getBookmarkedDiscussions();

      expect(bookmarks, isA<List<Map<String, dynamic>>>());
    });

    test('ChatService pulls active conversations safely', () async {
      final chatService = ChatService();
      final conversations = await chatService.getConversations();

      expect(conversations, isA<List<Map<String, dynamic>>>());
    });

    test('DiscussionService toggleLike returns false when offline/unauthenticated', () async {
      final discussionService = DiscussionService();
      final result = await discussionService.toggleLike('test-disc-id');
      expect(result, isFalse);

      final isLiked = await discussionService.isDiscussionLiked('test-disc-id');
      expect(isLiked, isFalse);
    });
  });
}

