import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/resources/pref_resources.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool(PrefResources.isAdmin) ?? false;
      log("is Admin $isAdmin");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            if (isAdmin) ...[
              ListTile(
                tileColor: context.colorScheme.surfaceContainerHighest,
                title: Text(AppStrings.shopDetails),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  context.router.pushNamed(AppRouter.shopDetails);
                },
              ),
            ],
            const SizedBox(height: 8),
            ListTile(
              tileColor: context.colorScheme.surfaceContainerHighest,
              title: const Text('Expenses'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                context.router.pushNamed(AppRouter.expenses);
              },
            ),
            const SizedBox(height: 8),
            if (isAdmin) ...[
              ListTile(
                tileColor: context.colorScheme.surfaceContainerHighest,
                title: const Text('Registered Users'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  context.router.pushNamed(AppRouter.registeredUsers);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
