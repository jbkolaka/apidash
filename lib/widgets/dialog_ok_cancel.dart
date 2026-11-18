import 'package:apidash/consts.dart';
import 'package:apidash/core/components/index.dart';
import 'package:flutter/material.dart';

void showOkCancelDialog(
  BuildContext context, {
  String? dialogTitle,
  String? content,
  String? buttonLabelOk,
  VoidCallback? onClickOk,
  String? buttonLabelCancel,
  VoidCallback? onClickCancel,
}) {
  showCModal(
    context,
    CModalProps(
      title: dialogTitle ?? "",
      body: SizedBox(width: 300, child: Text(content ?? "")),
      actions: <CModalAction>[
        CModalAction(
          label: buttonLabelCancel ?? kLabelCancel,
          kind: CModalActionKind.secondary,
          onPressed: onClickCancel,
        ),
        CModalAction(
          label: buttonLabelOk ?? kLabelOk,
          kind: CModalActionKind.primary,
          onPressed: onClickOk,
        ),
      ],
    ),
  );
}
