// ignore_for_file: use_build_context_synchronously

import 'package:apidash_design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'core/theme/theme.dart';
import 'widgets/widgets.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'consts.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowResized() {
    windowManager.getSize().then((value) {
      ref.read(settingsProvider.notifier).update(size: value);
    });
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

  @override
  void onWindowMoved() {
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if (ref.watch(
            settingsProvider.select((value) => value.promptBeforeClosing),
          ) &&
          ref.watch(hasUnsavedChangesProvider)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Save Changes'),
            content: const Text(
              'Want to save changes before you close API Dash?',
            ),
            actions: [
              OutlinedButton(
                child: const Text('No'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.setPreventClose(false);
                  await windowManager.close();
                },
              ),
              FilledButton(
                child: const Text('Save'),
                onPressed: () async {
                  await ref
                      .read(collectionStateNotifierProvider.notifier)
                      .saveData();
                  Navigator.of(context).pop();
                  await windowManager.setPreventClose(false);
                  await windowManager.close();
                },
              ),
            ],
          ),
        );
      } else {
        await windowManager.setPreventClose(false);
        await windowManager.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return context.isMediumWindow ? const MobileDashboard() : const Dashboard();
  }
}

class DashApp extends ConsumerStatefulWidget {
  const DashApp({super.key});

  @override
  ConsumerState<DashApp> createState() => _DashAppState();
}

class _DashAppState extends ConsumerState<DashApp> {
  late final AppThemeController _themeController;

  @override
  void initState() {
    super.initState();
    final isDark = ref.read(settingsProvider).isDark;
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
    ref.listen(settingsProvider.select((value) => value.isDark), (_, isDark) {
      _themeController.setThemeMode(
        isDark ? AppThemeMode.gray100 : AppThemeMode.white,
      );
    });
    final workspaceFolderPath = ref.watch(
      settingsProvider.select((value) => value.workspaceFolderPath),
    );
    final showWorkspaceSelector = kIsDesktop && (workspaceFolderPath == null);
    final userOnboarded = ref.watch(userOnboardedProvider);
    return AppThemeScope(
      controller: _themeController,
      child: ValueListenableBuilder<AppThemeMode>(
        valueListenable: _themeController,
        builder: (context, mode, _) => Portal(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeDataFor(mode),
            home: showWorkspaceSelector
                ? WorkspaceSelector(
                    onContinue: (val) async {
                      await initHiveBoxes(kIsDesktop, val);
                      ref
                          .read(settingsProvider.notifier)
                          .update(workspaceFolderPath: val);
                    },
                    onCancel: () async {
                      try {
                        await windowManager.destroy();
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  )
                : //Stack(
                  //  children: [
                  !kIsLinux && !kIsMobile
                ? const App()
                : context.isMediumWindow
                ? (kIsMobile && !userOnboarded)
                      ? OnboardingScreen(
                          onComplete: () async {
                            await setOnboardingStatusToSharedPrefs(
                              isOnboardingComplete: true,
                            );
                            ref.read(userOnboardedProvider.notifier).state =
                                true;
                          },
                        )
                      : const MobileDashboard()
                : const Dashboard(),
            //     if (kIsWindows)
            //       SizedBox(
            //         height: 29,
            //         child: WindowCaption(
            //           backgroundColor: Colors.transparent,
            //           brightness:
            //               isDarkMode ? Brightness.dark : Brightness.light,
            //         ),
            //       ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
