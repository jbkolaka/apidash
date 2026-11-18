import 'package:apidash/features/home/screen/home.dart';
import 'package:apidash/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';


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
        home: HomePage(),
      ),
    );
  }
}
