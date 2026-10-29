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
import '../../features/auth/screens/discussion/add_discussion_screen.dart';

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
  static const String addDiscussion = '/add-discussion';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case checkEmail:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => CheckEmailScreen(email: email),
        );
      case registerKtm:
        return MaterialPageRoute(
          builder: (_) => const RegisterKtmScreen(),
        );
      case registerForm:
        return MaterialPageRoute(
          builder: (_) => const RegisterFormScreen(),
        );
      case registerInfo:
        return MaterialPageRoute(
          builder: (_) => const RegisterInfoScreen(),
        );
      case emailVerification:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => EmailVerificationScreen(email: email),
        );
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      case addDiscussion:
        return MaterialPageRoute(
          builder: (_) => const AddDiscussionScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}
