import 'package:apidash/core/components/index.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';

void showAboutAppDialog(BuildContext context) {
  showCModal(
    context,
    CModalProps(
      title: 'About API Dash',
      size: CModalSize.large,
      body: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 540, maxHeight: 544),
        child: IntroMessage(),
      ),
      actions: <CModalAction>[
        CModalAction(label: 'Close', kind: CModalActionKind.secondary),
      ],
    ),
  );
}
