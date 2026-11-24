import 'package:flutter/widgets.dart';

import '../../../core/carbon.dart';

/// Small Carbon popover that labels an action trigger on hover.
class WorkSpacePopoverLabel extends StatelessWidget {
  const WorkSpacePopoverLabel({
    super.key,
    required this.label,
    required this.triggerBuilder,
    this.align = CPopoverAlignment.left,
  });

  final String label;
  final Widget Function(BuildContext, bool) triggerBuilder;
  final CPopoverAlignment align;

  @override
  Widget build(BuildContext context) {
    return CPopover(
      align: align,
      closeOnTapOutside: false,
      hitTestable: false,
      content: CText(data: label),
      triggerBuilder: (context, toggle, isOpen) => MouseRegion(
        onEnter: (_) {
          if (!isOpen) toggle();
        },
        onExit: (_) {
          if (isOpen) toggle();
        },
        child: triggerBuilder(context, isOpen),
      ),
    );
  }
}
