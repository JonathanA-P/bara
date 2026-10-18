import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';
import 'features/auth/screens/splash_screen/splash_screen.dart';

import 'core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BARA',
      home: SplashScreen(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}