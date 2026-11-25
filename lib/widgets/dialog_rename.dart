import 'package:flutter/material.dart';
import 'package:apidash/core/components/index.dart';
import 'package:apidash/core/theme/theme.dart';

void showRenameDialog(
  BuildContext context,
  String dialogTitle,
  String? name,
  Function(String) onRename,
) {
  showDialog(
    context: context,
    barrierColor: context.tokens.overlay,
    builder: (context) {
      return RenameDialogContent(
        dialogTitle: dialogTitle,
        onRename: onRename,
        name: name,
      );
    },
  );
}

class RenameDialogContent extends StatefulWidget {
  const RenameDialogContent({
    super.key,
    required this.dialogTitle,
    required this.onRename,
    this.name,
  });

  final String dialogTitle;
  final Function(String) onRename;
  final String? name;

  @override
  State<RenameDialogContent> createState() => _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name ?? "");
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CModal(
      props: CModalProps(
        title: widget.dialogTitle,
        body: SizedBox(
          width: 300,
          child: CTextField(
            autofocus: true,
            controller: controller,
            semanticLabel: 'New name',
            hint: "Enter new name",
          ),
        ),
        actions: <CModalAction>[
          CModalAction(
            label: 'Cancel',
            kind: CModalActionKind.secondary,
            dismissOnPressed: false,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CModalAction(
            label: 'Ok',
            kind: CModalActionKind.primary,
            dismissOnPressed: false,
            onPressed: () {
              final val = controller.text.trim();
              widget.onRename(val);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
