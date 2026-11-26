import 'package:flutter/material.dart';

import '../../../../core/carbon.dart';

/// Fixed-width method tag used as the leading icon for request rows.
class WorkspaceMethodTag extends StatelessWidget {
  const WorkspaceMethodTag({super.key, required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final type = switch (method.toUpperCase()) {
      'GET' => CTagType.green,
      'POST' => CTagType.warmGray,
      'PUT' => CTagType.blue,
      'DELETE' => CTagType.red,
      'PATCH' => CTagType.purple,
      _ => CTagType.gray,
    };

    return SizedBox(
      width: Spacing.v64px4remSpacing10,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: CTag(text: method, size: CTagSize.sm, type: type),
        ),
      ),
    );
  }
}
