import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen/splash_screen.dart';
import '../../features/auth/screens/onboarding/onboarding_screen.dart';
import '../../features/auth/screens/login/login_screen.dart';
import '../../features/auth/screens/login/register_screen.dart';
import '../../features/auth/screens/login/forgot_password_screen.dart';
import '../../features/auth/screens/home/main_screen.dart';
import '../../features/auth/screens/home/home_screen.dart';
import '../../features/auth/screens/profile/profile_screen.dart';
import '../../features/auth/screens/profile/edit_profile_screen.dart';
import '../../features/auth/screens/bookmark/bookmark_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/notification/screens/notification_screen.dart';
import '../../features/chat/screens/chat_list_screen.dart';
import '../../features/chat/screens/chat_room_screen.dart';
import '../../features/matching/screens/mentor_matching_screen.dart';
import '../../features/quiz/screens/competency_quiz_screen.dart';
import '../../features/report/screens/report_incident_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookmark = '/bookmark';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String notification = '/notification';
  static const String chat = '/chat';
  static const String chatRoom = '/chat-room';
  static const String mentorMatching = '/mentor-matching';
  static const String competencyQuiz = '/competency-quiz';
  static const String reportIncident = '/report-incident';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case explore:
        return MaterialPageRoute(builder: (_) => const ExploreScreen());
      case bookmark:
        return MaterialPageRoute(builder: (_) => const BookmarkScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case chatRoom:
        return MaterialPageRoute(builder: (_) => const ChatRoomScreen());
      case mentorMatching:
        return MaterialPageRoute(builder: (_) => const MentorMatchingScreen());
      case competencyQuiz:
        return MaterialPageRoute(builder: (_) => const CompetencyQuizScreen());
      case reportIncident:
        return MaterialPageRoute(builder: (_) => const ReportIncidentScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}