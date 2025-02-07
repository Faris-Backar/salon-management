import 'package:flutter/material.dart';
import 'package:salon_management/gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(Assets.images.logoWithName.path)),
    );
  }
}
