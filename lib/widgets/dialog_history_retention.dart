import 'package:apidash/consts.dart';
import 'package:apidash/core/components/index.dart';
import 'package:apidash/core/theme/theme.dart';
import 'package:flutter/material.dart';

void showHistoryRetentionDialog(
  BuildContext context,
  HistoryRetentionPeriod historyRetentionPeriod,
  Function(HistoryRetentionPeriod) onRetentionPeriodChange,
) {
  var selectedRetentionPeriod = historyRetentionPeriod;

  showCModal(
    context,
    CModalProps(
      title: 'Manage History',
      description:
          'Select the duration for which you want to retain your request history',
      body: StatefulBuilder(
        builder: (context, setLocalState) {
          final tokens = context.tokens;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: HistoryRetentionPeriod.values
                .map(
                  (period) => RadioListTile<HistoryRetentionPeriod>(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      period.label,
                      style: TextStyle(
                        color: selectedRetentionPeriod == period
                            ? tokens.textPrimary
                            : tokens.textSecondary,
                      ),
                    ),
                    secondary: Icon(
                      period.icon,
                      color: selectedRetentionPeriod == period
                          ? tokens.iconPrimary
                          : tokens.iconSecondary,
                    ),
                    value: period,
                    groupValue: selectedRetentionPeriod,
                    activeColor: tokens.buttonPrimary,
                    onChanged: (value) {
                      if (value != null) {
                        setLocalState(() => selectedRetentionPeriod = value);
                      }
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
      actions: <CModalAction>[
        const CModalAction(label: 'Cancel', kind: CModalActionKind.secondary),
        CModalAction(
          label: 'Confirm',
          kind: CModalActionKind.primary,
          onPressed: () => onRetentionPeriodChange(selectedRetentionPeriod),
        ),
      ],
    ),
  );
}
