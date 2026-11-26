import 'package:flutter/widgets.dart';
import '../../shared/index.dart';
import '../../theme/app_theme_tokens.dart';

abstract final class CBreadcrumbItemStyles {
  static const double itemSpacing = 4.0;

  static const double borderRadius = 4.0;

  static const Map<String, dynamic> animation = {
    'duration': Duration(milliseconds: 100),
    'curve': Curves.linear,
  };

  static Color backgroundColor(AppThemeTokens tokens, CWidgetState state) =>
      switch (state) {
        CWidgetState.focused => tokens.backgroundHover,
        _ => tokens.background,
      };

  static Color textColor(AppThemeTokens tokens, bool isCurrentPage) =>
      isCurrentPage ? tokens.textPrimary : tokens.linkPrimary;
}
