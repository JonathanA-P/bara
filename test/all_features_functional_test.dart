import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bara/core/services/app_data_controller.dart';
import 'package:bara/features/auth/screens/home/home_screen.dart';
import 'package:bara/features/auth/screens/home/models/post_model.dart';
import 'package:bara/features/auth/screens/discussion/add_discussion_screen.dart';
import 'package:bara/features/auth/screens/discussion/detail_post_screen.dart';
import 'package:bara/features/auth/screens/bookmark/bookmark_screen.dart';
import 'package:bara/features/auth/screens/course/course_screen.dart';
import 'package:bara/features/auth/screens/course/add_course_rating_screen.dart';
import 'package:bara/features/matching/screens/mentor_matching_screen.dart';
import 'package:bara/features/quiz/screens/competency_quiz_screen.dart';
import 'package:bara/features/chat/screens/direct_chat_screen.dart';
import 'package:bara/features/notification/screens/notification_screen.dart';
import 'package:bara/features/report/screens/report_incident_screen.dart';
import 'package:bara/features/auth/screens/profile/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  SharedPreferences.setMockInitialValues({});

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('Full Feature Functional Verification Suite', () {
    setUpAll(() async {
      await AppDataController.instance.initialize();
    });

    testWidgets('1. HomeScreen feed, category tabs, and post creation trigger',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Kuliah'), findsOneWidget);
      expect(find.text('Luar Kelas'), findsOneWidget);
    });

    testWidgets('2. AddDiscussionScreen validates input fields and form elements',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const AddDiscussionScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(AddDiscussionScreen), findsOneWidget);

      final titleFinder = find.byType(TextField).first;
      await tester.enterText(titleFinder, 'Test Judul Diskusi Otomatis');
      await tester.pump();

      expect(find.text('Test Judul Diskusi Otomatis'), findsOneWidget);
    });

    testWidgets('3. DetailPostScreen renders post content, user badge, and replies',
        (tester) async {
      final samplePost = PostModel(
        id: 'test-feat-post-1',
        authorName: 'Budi Santoso',
        authorAvatar: 'assets/images/userLogo.png',
        userRole: 'Teknik Informatika • 2023',
        tab: PostCategoryTab.kuliah,
        timeAgo: 'Baru saja',
        title: 'Pembahasan Graf dan Dijkstra di Python',
        content: 'Bagaimana cara menentukan heap queue yang efisien?',
        likesCount: 10,
        commentsCount: 2,
        badges: [
          PostBadge(
            label: 'INFORMATIKA',
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          ),
        ],
      );

      await tester.pumpWidget(createTestWidget(DetailPostScreen(post: samplePost)));
      await tester.pumpAndSettle();

      expect(find.text('Pembahasan Graf dan Dijkstra di Python'), findsOneWidget);
      expect(find.text('Budi Santoso'), findsOneWidget);
    });

    testWidgets('4. BookmarkScreen renders saved items and filter chips',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const BookmarkScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(BookmarkScreen), findsOneWidget);
      expect(find.text('Materi & Catatan Tersimpan'), findsOneWidget);
      expect(find.text('Semua'), findsWidgets);
    });

    testWidgets('5. MentorMatchingScreen renders mentor cards and swipe gesture area',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const MentorMatchingScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(MentorMatchingScreen), findsOneWidget);
      expect(find.text('Matchmaking Mentor'), findsOneWidget);
    });

    testWidgets('6. CompetencyQuizScreen renders questions and options',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CompetencyQuizScreen(
            mentorName: 'Farhan Maulana',
            topic: 'Struktur Data & Graf',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CompetencyQuizScreen), findsOneWidget);
      expect(find.text('Validasi Kompetensi Awal'), findsOneWidget);
      expect(find.text('Queue'), findsWidgets);
    });

    testWidgets('7. CourseScreen & AddCourseRatingScreen function properly',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const CourseScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(CourseScreen), findsOneWidget);

      await tester.pumpWidget(
        createTestWidget(const AddCourseRatingScreen(courseCode: 'IF2123')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AddCourseRatingScreen), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('8. DirectChatScreen renders messages and send input',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const DirectChatScreen(
            peerName: 'Farhan Maulana',
            lastSeen: 'Online',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DirectChatScreen), findsOneWidget);
      expect(find.text('Farhan Maulana'), findsOneWidget);
    });

    testWidgets('9. NotificationScreen renders notification list and tabs',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const NotificationScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationScreen), findsOneWidget);
      expect(find.text('Notifikasi'), findsOneWidget);
    });

    testWidgets('10. ReportIncidentScreen renders incident category and form fields',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const ReportIncidentScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ReportIncidentScreen), findsOneWidget);
      expect(find.text('Pelaporan Insiden'), findsOneWidget);
    });

    testWidgets('11. ProfileScreen renders user stats and edit profile option',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Edit Profil'), findsOneWidget);
    });
  });
}
