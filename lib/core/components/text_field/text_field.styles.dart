import 'package:flutter/material.dart';

import '../../shared/index.dart';
import '../../theme/theme.dart';

import 'text_field.widget.dart';

abstract class CTextfieldStyles {
  static const double labelFontSize = 14.0;
  static const String labelFontFamily = CFonts.primaryRegular;

  static const double textFontSize = 14.0;
  static const String textFontFamily = CFonts.primaryRegular;

  static const double hintFontSize = 15.0;
  static const String hintFontFamily = CFonts.primaryRegular;

  static const double descriptionFontSize = 14.0;
  static const String descriptionFontFamily = CFonts.primaryRegular;

  static Color cursorColor(AppThemeTokens tokens) => tokens.textPrimary;

  static InputBorder border(
    AppThemeTokens tokens,
    CTextfieldKind kind,
    CWidgetState state,
  ) {
    if (state == CWidgetState.disabled) {
      return const UnderlineInputBorder(borderSide: BorderSide.none);
    }
    if (state == CWidgetState.focused) {
      final color = switch (kind) {
        CTextfieldKind.success => tokens.supportSuccess,
        CTextfieldKind.warning => tokens.supportWarning,
        CTextfieldKind.error => tokens.supportError,
        CTextfieldKind.primary => tokens.focus,
      };
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: color, width: 2),
      );
    }
    return UnderlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: tokens.borderStrong01, width: 1),
    );
  }

  static Color descriptionColor(
    AppThemeTokens tokens,
    CTextfieldKind kind,
    CWidgetState state,
  ) {
    if (state == CWidgetState.disabled) return tokens.textDisabled;
    return switch (kind) {
      CTextfieldKind.success => tokens.supportSuccess,
      CTextfieldKind.warning => tokens.supportWarning,
      CTextfieldKind.error => tokens.supportError,
      CTextfieldKind.primary => tokens.textSecondary,
    };
  }

  static Color textColor(AppThemeTokens tokens, CWidgetState state) {
    return state == CWidgetState.disabled
        ? tokens.textDisabled
        : tokens.textPrimary;
  }

  static Color labelColor(AppThemeTokens tokens, CWidgetState state) {
    return state == CWidgetState.disabled
        ? tokens.textDisabled
        : tokens.textSecondary;
  }

  static Color hintColor(AppThemeTokens tokens, CWidgetState state) {
    return state == CWidgetState.disabled
        ? tokens.textDisabled
        : tokens.textPlaceholder;
  }

  static Color backgroundColor(AppThemeTokens tokens, CWidgetState state) {
    return state == CWidgetState.disabled ? tokens.field02 : tokens.field01;
  }

  static Color iconColor(AppThemeTokens tokens, CWidgetState state) {
    return state == CWidgetState.disabled
        ? tokens.textDisabled
        : tokens.iconPrimary;
  }
}
