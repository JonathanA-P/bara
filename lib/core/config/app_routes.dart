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
        return smoothRoute(
          EmailVerificationScreen(email: email),
          settings: settings,
        );
      case main:
        return smoothRoute(const MainScreen(), settings: settings);
      case addDiscussion:
        return smoothRoute(const AddDiscussionScreen(), settings: settings);
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
