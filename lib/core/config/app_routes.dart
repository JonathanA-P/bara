import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen/splash_screen.dart';
import '../../features/auth/screens/onboarding/onboarding_screen.dart';
import '../../features/auth/screens/login/login_screen.dart';
import '../../features/auth/screens/forgot_password/forgot_password_screen.dart';
import '../../features/auth/screens/forgot_password/check_email_screen.dart';
import '../../features/auth/screens/register/register_ktm_screen.dart';
import '../../features/auth/screens/register/register_form_screen.dart';
import '../../features/auth/screens/register/register_info_screen.dart';
import '../../features/auth/screens/register/email_verification_screen.dart';
import '../../features/auth/screens/home/main_screen.dart';
import '../../features/auth/screens/home/home_screen.dart';
import '../../features/auth/screens/discussion/add_discussion_screen.dart';
import '../../features/auth/screens/profile/profile_screen.dart';
import '../../features/auth/screens/profile/edit_profile_screen.dart';
import '../../features/auth/screens/bookmark/bookmark_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/explore/screens/search_screen.dart';
import '../../features/notification/screens/notification_screen.dart';
import '../../features/chat/screens/chat_list_screen.dart';
import '../../features/chat/screens/chat_room_screen.dart';
import '../../features/chat/screens/direct_chat_screen.dart';
import '../../features/chat/screens/camera_screen.dart';
import '../../features/chat/screens/notification_chat_screen.dart';
import '../../features/matching/screens/mentor_matching_screen.dart';
import '../../features/quiz/screens/competency_quiz_screen.dart';
import '../../features/report/screens/report_incident_screen.dart';
import '../../features/auth/screens/course/course_screen.dart';
import '../../features/auth/screens/course/course_detail_screen.dart';
import '../../features/auth/screens/course/course_rating_screen.dart';
import '../../features/auth/screens/course/add_course_rating_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String checkEmail = '/check-email';
  static const String registerKtm = '/register-ktm';
  static const String registerForm = '/register-form';
  static const String registerInfo = '/register-info';
  static const String emailVerification = '/email-verification';
  static const String main = '/main';
  static const String home = '/home';
  static const String addDiscussion = '/add-discussion';
  static const String search = '/search';
  static const String explore = '/explore';
  static const String bookmark = '/bookmark';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String notification = '/notification';
  static const String chat = '/chat';
  static const String chatRoom = '/chat-room';
  static const String directChat = '/direct-chat';
  static const String camera = '/camera';
  static const String notificationChat = '/notification-chat';
  static const String mentorMatching = '/mentor-matching';
  static const String competencyQuiz = '/competency-quiz';
  static const String reportIncident = '/report-incident';
  static const String course = '/course';
  static const String courseDetail = '/course-detail';
  static const String courseRating = '/course-rating';
  static const String addCourseRating = '/add-course-rating';

  /// Smooth Instagram-like parallax slide + fade transition
  static Route<T> smoothRoute<T>(Widget page, {RouteSettings? settings}) {
    return CupertinoPageRoute<T>(
      settings: settings,
      builder: (_) => page,
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return smoothRoute(const SplashScreen(), settings: settings);
      case onboarding:
        return smoothRoute(const OnboardingScreen(), settings: settings);
      case login:
        return smoothRoute(const LoginScreen(), settings: settings);
      case forgotPassword:
        return smoothRoute(const ForgotPasswordScreen(), settings: settings);
      case checkEmail:
        final email = settings.arguments as String? ?? '';
        return smoothRoute(CheckEmailScreen(email: email), settings: settings);
      case registerKtm:
        return smoothRoute(const RegisterKtmScreen(), settings: settings);
      case registerForm:
        return smoothRoute(const RegisterFormScreen(), settings: settings);
      case registerInfo:
        return smoothRoute(const RegisterInfoScreen(), settings: settings);
      case emailVerification:
        final email = settings.arguments as String? ?? '';
        return smoothRoute(EmailVerificationScreen(email: email), settings: settings);
      case main:
        return smoothRoute(const MainScreen(), settings: settings);
      case home:
        return smoothRoute(const HomeScreen(), settings: settings);
      case addDiscussion:
        return smoothRoute(const AddDiscussionScreen(), settings: settings);
      case search:
        return smoothRoute(const SearchScreen(), settings: settings);
      case explore:
        return smoothRoute(const ExploreScreen(), settings: settings);
      case bookmark:
        return smoothRoute(const BookmarkScreen(), settings: settings);
      case profile:
        return smoothRoute(const ProfileScreen(), settings: settings);
      case editProfile:
        return smoothRoute(const EditProfileScreen(), settings: settings);
      case notification:
        return smoothRoute(const NotificationScreen(), settings: settings);
      case chat:
        return smoothRoute(const ChatListScreen(), settings: settings);
      case chatRoom:
        return smoothRoute(const ChatRoomScreen(), settings: settings);
      case directChat:
        return smoothRoute(const DirectChatScreen(), settings: settings);
      case camera:
        return smoothRoute(const CameraScreen(), settings: settings);
      case notificationChat:
        return smoothRoute(const NotificationChatScreen(), settings: settings);
      case mentorMatching:
        return smoothRoute(const MentorMatchingScreen(), settings: settings);
      case competencyQuiz:
        return smoothRoute(const CompetencyQuizScreen(), settings: settings);
      case reportIncident:
        return smoothRoute(const ReportIncidentScreen(), settings: settings);
      case course:
        return smoothRoute(const CourseScreen(), settings: settings);
      case courseDetail:
        return smoothRoute(const CourseDetailScreen(), settings: settings);
      case courseRating:
        return smoothRoute(const CourseRatingScreen(), settings: settings);
      case addCourseRating:
        return smoothRoute(const AddCourseRatingScreen(), settings: settings);
      default:
        return smoothRoute(
          const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
          settings: settings,
        );
    }
  }
}
