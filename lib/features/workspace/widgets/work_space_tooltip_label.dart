import 'package:flutter/widgets.dart';

import '../../../core/carbon.dart';
import '../../../core/components/tooltip/tooltip.props.dart'
    as tooltip
    show CTooltipAlignment;

/// Small Carbon tooltip that labels an action trigger on hover.
class WorkSpaceTooltipLabel extends StatelessWidget {
  const WorkSpaceTooltipLabel({
    super.key,
    required this.label,
    required this.child,
    this.align = tooltip.CTooltipAlignment.left,
  });

  final String label;
  final Widget child;
  final tooltip.CTooltipAlignment align;

  @override
  Widget build(BuildContext context) {
    return CTooltip(
      label: label,
      align: align,
      caret: true,
      offset: 0,
      child: child,
    );
  }
}
