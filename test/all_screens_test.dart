import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bara/features/explore/screens/explore_screen.dart';
import 'package:bara/features/notification/screens/notification_screen.dart';
import 'package:bara/features/chat/screens/chat_list_screen.dart';
import 'package:bara/features/chat/screens/chat_room_screen.dart';
import 'package:bara/features/matching/screens/mentor_matching_screen.dart';
import 'package:bara/features/quiz/screens/competency_quiz_screen.dart';
import 'package:bara/features/report/screens/report_incident_screen.dart';
import 'package:bara/features/auth/screens/login/register_screen.dart';
import 'package:bara/features/auth/screens/login/otp_verification_screen.dart';
import 'package:bara/features/auth/screens/login/login_screen.dart';
import 'package:bara/features/auth/screens/home/home_screen.dart';
import 'package:bara/features/auth/screens/discussion/detail_post_screen.dart';
import 'package:bara/features/auth/screens/profile/profile_screen.dart';

void main() {
  testWidgets('ExploreScreen renders successfully', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));
    expect(find.text('Eksplorasi'), findsOneWidget);
    expect(find.text('Farhan Maulana'), findsOneWidget);
  });

  testWidgets('NotificationScreen renders successfully', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotificationScreen()));
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Permintaan Bimbingan Diterima!'), findsOneWidget);
  });

  testWidgets('ChatListScreen renders successfully', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatListScreen()));
    expect(find.text('Pesan & Bimbingan'), findsOneWidget);
    expect(find.text('Farhan Maulana'), findsOneWidget);
  });

  testWidgets('ChatRoomScreen renders successfully', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatRoomScreen()));
    expect(find.text('Farhan Maulana'), findsOneWidget);
    expect(find.text('Tulis pesan atau pertanyaan...'), findsOneWidget);
  });

  testWidgets('MentorMatchingScreen renders successfully', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MentorMatchingScreen()));
    expect(find.text('Matchmaking Mentor'), findsOneWidget);
    expect(find.text('Farhan Maulana'), findsOneWidget);
  });

  testWidgets('CompetencyQuizScreen renders questions and options', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CompetencyQuizScreen()));
    expect(find.text('Validasi Kompetensi Awal'), findsOneWidget);
    expect(find.text('Breadth-First Search (BFS)'), findsOneWidget);
  });

  testWidgets('ReportIncidentScreen renders form fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReportIncidentScreen()));
    expect(find.text('Pelaporan Insiden'), findsOneWidget);
    expect(find.text('Subjek / Ringkasan Insiden'), findsOneWidget);
  });

  testWidgets('RegisterScreen renders form fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    expect(find.text('Daftar Akun Baru'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
  });

  testWidgets('HomeScreen renders feed and filters successfully', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('BARA'), findsOneWidget);
    expect(find.text('For You'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });

  testWidgets('DetailPostScreen renders post and comment field', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DetailPostScreen()));
    expect(find.text('BARA'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
    expect(find.text('Tulis sesuatu'), findsOneWidget);
  });

  testWidgets('ProfileScreen renders profile header and settings', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('Edit Profil'), findsOneWidget);
  });

  testWidgets('LoginScreen renders fields and login button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    expect(find.text('Log in with University SSO'), findsOneWidget);
  });

  testWidgets('OtpVerificationScreen renders verification UI', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OtpVerificationScreen(email: 'test@student.ub.ac.id'),
    ));
    expect(find.text('Verifikasi Kode OTP'), findsOneWidget);
    expect(find.text('test@student.ub.ac.id'), findsOneWidget);
    expect(find.text('Verifikasi Akun'), findsOneWidget);
  });
}


