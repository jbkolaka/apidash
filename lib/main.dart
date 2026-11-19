import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';
import 'screens/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ApiDashApp()));
}

/// New app root. Starts on the fresh home page.
class ApiDashApp extends StatelessWidget {
  const ApiDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'API Dash',
        theme: AppTheme.whiteTheme,
        darkTheme: AppTheme.gray100Theme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
