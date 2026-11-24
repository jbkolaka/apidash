import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/carbon.dart';
import 'work_space_model.dart';
import 'work_space_tooltip_label.dart';

/// Body, headers, and cookies response viewer from the workbench layout.
class WorkSpaceResponseViewer extends StatefulWidget {
  const WorkSpaceResponseViewer({super.key, required this.response});

  final WorkspaceResponse? response;

  @override
  State<WorkSpaceResponseViewer> createState() =>
      _WorkSpaceResponseViewerState();
}

class _WorkSpaceResponseViewerState extends State<WorkSpaceResponseViewer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final response = widget.response;

    return Container(
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border(top: BorderSide(color: tokens.borderSubtle01)),
      ),
      child: Column(
        children: [
          Container(
            height: Spacing.v40px25remSpacing08,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.v16px1remSpacing05,
            ),
            decoration: BoxDecoration(
              color: tokens.layer02,
              border: Border(bottom: BorderSide(color: tokens.borderSubtle01)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final showMetadata =
                    constraints.maxWidth >= 720 && response != null;
                return Row(
                  children: [
                    Flexible(
                      child: CContentSwitcher(
                        props: CContentSwitcherProps(
                          size: CContentSwitcherSize.sm,
                          expand: false,
                          initialIndex: 0,
                          options: [
                            const CContentSwitcherOption(label: 'Body'),
                            CContentSwitcherOption(
                              label:
                                  'Headers (${response?.headers.length ?? 0})',
                            ),
                            const CContentSwitcherOption(label: 'Cookies'),
                          ],
                          onSelectionChanged: (index) =>
                              setState(() => _selectedIndex = index),
                        ),
                      ),
                    ),
                    if (showMetadata)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StatusPill(response: response),
                              const SizedBox(
                                width: Spacing.v12px075remSpacing04,
                              ),
                              _Metadata(
                                icon: CIcons.timer,
                                label: 'Time: ${response.timeMs} ms',
                              ),
                              const SizedBox(
                                width: Spacing.v12px075remSpacing04,
                              ),
                              _Metadata(
                                icon: CIcons.dataView,
                                label: 'Size: ${response.size}',
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(child: _buildContent(context, response)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WorkspaceResponse? response) {
    if (response == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CIcons.send, size: 36, color: context.tokens.iconSecondary),
            const SizedBox(height: Spacing.v8px05remSpacing03),
            Text(
              'Enter a URL and click Send to get a response',
              style: TypeScale.bodyCompact01.copyWith(
                color: context.tokens.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return switch (_selectedIndex) {
      0 => _ResponseBody(
        response: response,
        onCopy: () => _copyResponse(response.body),
      ),
      1 => _ResponseHeaders(headers: response.headers),
      _ => Center(
        child: Text(
          'No Cookies',
          style: TypeScale.bodyCompact01.copyWith(
            color: context.tokens.textSecondary,
          ),
        ),
      ),
    };
  }

  Future<void> _copyResponse(String body) async {
    await Clipboard.setData(ClipboardData(text: body));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied response to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.response});

  final WorkspaceResponse response;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = workspaceStatusColor(response.statusCode, tokens);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v8px05remSpacing03,
        vertical: Spacing.v4px025remSpacing02,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Status: ',
            style: TypeScale.bodyCompact01.copyWith(color: color),
          ),
          Text(
            response.statusLabel,
            style: TypeScale.bodyCompact01.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: tokens.iconSecondary),
        const SizedBox(width: Spacing.v4px025remSpacing02),
        Text(
          label,
          style: TypeScale.bodyCompact01.copyWith(color: tokens.textSecondary),
        ),
      ],
    );
  }
}

class _ResponseBody extends StatelessWidget {
  const _ResponseBody({required this.response, required this.onCopy});

  final WorkspaceResponse response;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
          child: SelectableText(
            response.body,
            style: TypeScale.bodyCompact01.copyWith(
              fontFamily: 'monospace',
              color: tokens.linkPrimary,
            ),
          ),
        ),
        Positioned(
          top: Spacing.v4px025remSpacing02,
          right: Spacing.v4px025remSpacing02,
          child: WorkSpaceTooltipLabel(
            label: 'Copy to clipboard',
            child: SizedBox(
              width: 16,
              height: 16,
              child: InkWell(
                onTap: onCopy,
                child: Icon(CIcons.copy, size: 16, color: tokens.iconSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResponseHeaders extends StatelessWidget {
  const _ResponseHeaders({required this.headers});

  final Map<String, String> headers;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final entries = headers.entries.toList();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.v4px025remSpacing02,
      ),
      itemCount: entries.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: tokens.borderSubtle00),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v16px1remSpacing05,
            vertical: Spacing.v8px05remSpacing03,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 220,
                child: Text(
                  entry.key,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: tokens.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: SelectableText(
                  entry.value,
                  style: TypeScale.bodyCompact01.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
