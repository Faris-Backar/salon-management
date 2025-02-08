import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/routes/app_router.gr.dart';
import 'package:salon_management/gen/assets.gen.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      if (mounted) {
        context.router.popAndPush(HomeRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(Assets.images.logoWithName.path)),
    );
  }
}
