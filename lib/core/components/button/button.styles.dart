import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../shared/index.dart';

import 'button.widget.dart';

abstract class CButtonStyles {
  /// Foreground color for the given [kind] and [state].
  static Color contentColor(
    AppThemeTokens tokens,
    CButtonKind kind,
    CWidgetState state,
  ) {
    if (state == CWidgetState.disabled) {
      return kind == CButtonKind.ghost || kind == CButtonKind.tertiary
          ? tokens.textDisabled
          : tokens.textOnColorDisabled;
    }
    switch (kind) {
      case CButtonKind.primary:
      case CButtonKind.secondary:
      case CButtonKind.danger:
        return tokens.textOnColor;
      case CButtonKind.tertiary:
        return tokens.textInverse;
      case CButtonKind.ghost:
        return tokens.linkPrimary;
    }
  }

  /// Background color for the given [kind] and [state].
  static Color backgroundColor(
    AppThemeTokens tokens,
    CButtonKind kind,
    CWidgetState state,
  ) {
    final focused = state == CWidgetState.focused;
    final disabled = state == CWidgetState.disabled;
    switch (kind) {
      case CButtonKind.primary:
        if (disabled) return tokens.buttonDisabled;
        return focused ? tokens.buttonPrimaryActive : tokens.buttonPrimary;
      case CButtonKind.secondary:
        if (disabled) return tokens.buttonDisabled;
        return focused ? tokens.buttonSecondaryActive : tokens.buttonSecondary;
      case CButtonKind.danger:
        if (disabled) return tokens.buttonDisabled;
        return focused ? tokens.buttonDangerActive : tokens.buttonDangerPrimary;
      case CButtonKind.tertiary:
        if (disabled) return tokens.buttonDisabled;
        return focused
            ? tokens.backgroundInverseHover
            : tokens.backgroundInverse;
      case CButtonKind.ghost:
        if (disabled) return CColors.transparent;
        return focused ? tokens.layerHover01 : CColors.transparent;
    }
  }

  /// Inner focus ring.
  static Border firstBorder(
    AppThemeTokens tokens,
    CButtonKind kind,
    CWidgetState state,
  ) {
    if (state != CWidgetState.focused || kind == CButtonKind.ghost) {
      return Border.all(color: CColors.transparent, width: 0);
    }
    return Border.all(color: tokens.focusInset, width: 2);
  }

  /// Outer focus ring / resting border.
  static Border secondBorder(
    AppThemeTokens tokens,
    CButtonKind kind,
    CWidgetState state,
  ) {
    if (state == CWidgetState.focused && kind != CButtonKind.ghost) {
      return Border.all(color: tokens.focus, width: 2);
    }
    if (state == CWidgetState.disabled) {
      return Border.all(color: CColors.transparent, width: 0);
    }
    switch (kind) {
      case CButtonKind.tertiary:
        return Border.all(color: tokens.borderSubtle01, width: 1);
      case CButtonKind.primary:
      case CButtonKind.secondary:
      case CButtonKind.danger:
      case CButtonKind.ghost:
        return Border.all(color: CColors.transparent, width: 0);
    }
  }

  static final Map<String, dynamic> backgroundColorAnimation = {
    'duration': Duration(milliseconds: 65),
    'curve': Curves.easeInOut,
  };

  static final Map<CButtonKind, Map<String, dynamic>> firstBorderAnimation = {
    CButtonKind.primary: {
      'duration': Duration(milliseconds: 0),
      'curve': Curves.easeInOut,
    },
    CButtonKind.secondary: {
      'duration': Duration(milliseconds: 0),
      'curve': Curves.easeInOut,
    },
    CButtonKind.danger: {
      'duration': Duration(milliseconds: 0),
      'curve': Curves.easeInOut,
    },
    CButtonKind.tertiary: {
      'duration': Duration(milliseconds: 80),
      'curve': Curves.easeInOut,
    },
    CButtonKind.ghost: {
      'duration': Duration(milliseconds: 80),
      'curve': Curves.easeInOut,
    },
  };

  static final Map<String, dynamic> secondBorderAnimation = {
    'duration': Duration(milliseconds: 0),
    'curve': Curves.easeInOut,
  };

  static final Map<CButtonSize, Size> dimensions = {
    CButtonSize.regular: Size(48, 48),
    CButtonSize.md: Size(40, 40),
    CButtonSize.sm: Size(32, 32),
  };

  static final Map<CButtonSize, double> padding = {
    CButtonSize.regular: 16.0,
    CButtonSize.md: 16.0,
    CButtonSize.sm: 13.0,
  };
}
