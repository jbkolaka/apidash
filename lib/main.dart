import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';
import 'features/home/screen/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ApiDashApp()));
}

/// New app root. Starts on the fresh home page.
class ApiDashApp extends StatefulWidget {
  const ApiDashApp({super.key});

  @override
  State<ApiDashApp> createState() => _ApiDashAppState();
}

class _ApiDashAppState extends State<ApiDashApp> {
  late final AppThemeController _themeController;

  @override
  void initState() {
    super.initState();
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
    _themeController = AppThemeController(
      isDark ? AppThemeMode.gray100 : AppThemeMode.white,
    );
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _themeController,
      child: ValueListenableBuilder<AppThemeMode>(
        valueListenable: _themeController,
        builder: (context, mode, _) => Portal(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'API Dash',
            theme: AppTheme.themeDataFor(mode),
            home: const Home(),
          ),
        ),
      ),
    );
  }
}
