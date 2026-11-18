import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

import '../consts.dart';
import '../models/settings_model.dart';
import 'hive_services.dart';
import 'history_service.dart';
import 'window_services.dart';

/// Initializes Hive boxes used by the app.
Future<bool> initApp(
  bool initializeUsingPath, {
  SettingsModel? settingsModel,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  try {
    final openBoxesStatus = await initHiveBoxes(
      initializeUsingPath,
      settingsModel?.workspaceFolderPath,
    );
    if (openBoxesStatus) {
      await autoClearHistory(settingsModel: settingsModel);
    }
    return openBoxesStatus;
  } catch (e) {
    debugPrint("initApp failed due to $e");
    return false;
  }
}

/// Configures the desktop window.
Future<void> initWindow({Size? sz, SettingsModel? settingsModel}) async {
  if (kIsLinux) {
    await setupInitialWindow(sz: sz ?? settingsModel?.size);
  }
  if (kIsMacOS || kIsWindows) {
    if (sz != null) {
      await setupWindow(sz: sz, off: const Offset(100, 100));
    } else {
      await setupWindow(sz: settingsModel?.size, off: settingsModel?.offset);
    }
  }
}
