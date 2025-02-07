import 'package:flutter/material.dart';
import 'package:salon_management/app/feature/splash/presentation/pages/splash_screen.dart';

class SalonManagementApp extends StatelessWidget {
  const SalonManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
