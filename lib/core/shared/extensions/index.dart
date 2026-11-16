import 'package:flutter/material.dart';
import '../enums/index.dart';
import '../pmvvm.dart';

extension CThemeContextExtension on BuildContext {
  get cTheme {
    return fetch<CTheme>();
  }
}
