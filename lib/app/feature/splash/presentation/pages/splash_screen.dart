import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/resources/pref_resources.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/routes/app_router.gr.dart';
import 'package:salon_management/app/feature/settings/data/services/shop_details_service.dart';
import 'package:salon_management/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to track if shop details have been loaded
final shopDetailsLoadedProvider = StateProvider<bool>((ref) => false);

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Explicitly preload shop details and ensure the provider is initialized
      await ref.read(shopDetailsProvider.future).then((details) {
        // Set the loaded flag to true to indicate successful loading
        ref.read(shopDetailsLoadedProvider.notifier).state = true;
        debugPrint('Shop details loaded successfully: ${details.name}');
      });

      // Also initialize the shop details stream provider to ensure it's active
      ref.read(shopDetailsStreamProvider);

      // Wait for at least 2 seconds for splash screen
      await Future.delayed(const Duration(seconds: 2));

      // Check if user is authenticated
      final prefs = await SharedPreferences.getInstance();
      final isAuthenticated =
          prefs.getBool(PrefResources.isAuthenticated) ?? false;

      if (mounted) {
        if (isAuthenticated) {
          context.router.replaceNamed(AppRouter.dashBoardScreen);
        } else {
          context.router.replaceNamed(AppRouter.loginScreen);
        }
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      // Set shop details loaded to false to indicate it failed
      ref.read(shopDetailsLoadedProvider.notifier).state = false;

      // Continue to login/dashboard even if shop details loading fails
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final isAuthenticated =
            prefs.getBool(PrefResources.isAuthenticated) ?? false;

        if (mounted) {
          if (isAuthenticated) {
            context.router.replaceNamed(AppRouter.dashBoardScreen);
          } else {
            context.router.replaceNamed(AppRouter.loginScreen);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 0.6.sh,
                width: 0.6.sw,
                child: Image.asset(Assets.images.logoWithName.path)),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
