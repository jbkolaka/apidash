import 'package:flutter/widgets.dart';

/// Carbon productive type scale used by the app shell and core components.
///
/// Sizes and line heights follow the Carbon Design System type tokens so
/// typography stays consistent across the app instead of using magic numbers.
abstract final class TypeScale {
  /// Caption 01 — 12/16.
  static const TextStyle caption01 = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.32,
  );

  /// Label 01 — 12/16, medium weight.
  static const TextStyle label01 = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.32,
    fontWeight: FontWeight.w500,
  );

  /// Body compact 01 — 14/18.
  static const TextStyle bodyCompact01 = TextStyle(
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: 0.16,
  );

  /// Body 01 — 16/24.
  static const TextStyle body01 = TextStyle(fontSize: 16, height: 24 / 16);

  /// Heading 01 — 14/20, semibold.
  static const TextStyle heading01 = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  /// Heading 02 — 16/22, semibold.
  static const TextStyle heading02 = TextStyle(
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
  );

  /// Heading 03 — 20/28, semibold.
  static const TextStyle heading03 = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
  );

  /// Heading 04 — 28/36.
  static const TextStyle heading04 = TextStyle(fontSize: 28, height: 36 / 28);

  /// Heading 05 — 32/40.
  static const TextStyle heading05 = TextStyle(fontSize: 32, height: 40 / 32);

  /// Heading 06 — 42/50.
  static const TextStyle heading06 = TextStyle(fontSize: 42, height: 50 / 42);

  /// Heading 07 — 54/64.
  static const TextStyle heading07 = TextStyle(fontSize: 54, height: 64 / 54);
}
