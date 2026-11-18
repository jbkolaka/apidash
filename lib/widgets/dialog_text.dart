import 'package:apidash/consts.dart';
import 'package:apidash/core/components/index.dart';
import 'package:flutter/material.dart';

void showTextDialog(
  BuildContext context, {
  String? dialogTitle,
  String? content,
  String? buttonLabel,
}) {
  showCModal(
    context,
    CModalProps(
      title: dialogTitle ?? "",
      body: SizedBox(width: 300, child: Text(content ?? "")),
      actions: <CModalAction>[
        CModalAction(
          label: buttonLabel ?? kLabelOk,
          kind: CModalActionKind.primary,
        ),
      ],
    ),
  );
}
