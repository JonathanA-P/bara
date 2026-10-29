import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';
import 'features/auth/screens/splash_screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiGavi',
      home: SplashScreen(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}