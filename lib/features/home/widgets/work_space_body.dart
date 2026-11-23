import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

class WorkSpaceBody extends StatefulWidget {
  const WorkSpaceBody({super.key});

  @override
  State<WorkSpaceBody> createState() => _WorkSpaceBodyState();
}

class _WorkSpaceBodyState extends State<WorkSpaceBody> {
  int _page = 1;
  int _pageSize = 8;

  static List<CDataTableColumn> _columns(double availableWidth) {
    final width = availableWidth > 2 ? availableWidth - 2 : availableWidth;
    return [
      CDataTableColumn(key: 'name', label: 'Name', width: width * 0.38),
      CDataTableColumn(key: 'type', label: 'Type', width: width * 0.20),
      CDataTableColumn(
        key: 'updated',
        label: 'Last updated',
        width: width * 0.24,
      ),
      CDataTableColumn(
        key: 'requests',
        label: 'Requests',
        width: width * 0.18,
        sortable: false,
      ),
    ];
  }

  static final List<Map<String, Object?>> _rows = List.generate(30, (index) {
    final number = index + 1;
    return {
      'name': number == 1 ? 'Sample API' : 'Collection $number',
      'type': number % 4 == 0 ? 'Environment' : 'Collection',
      'updated': number <= 3
          ? 'Today'
          : number <= 8
          ? 'This week'
          : 'Last month',
      'requests': '${(number * 3) % 17}',
    };
  });

  int _rowsThatFit(double viewportHeight) {
    const verticalPadding = Spacing.v32px2remSpacing07 * 2;
    const headingHeight = 40.0;
    const headingGap = Spacing.v24px15remSpacing06;
    const tableTitleHeight = 80.0;
    const paginationHeight = 64.0;

    final available =
        viewportHeight -
        verticalPadding -
        headingHeight -
        headingGap -
        tableTitleHeight -
        CDataTableStyles.headerHeight -
        paginationHeight;
    final rows = available ~/ CDataTableStyles.defaultRowHeight;
    if (rows < 3) return 3;
    if (rows > 12) return 12;
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final capacity = _rowsThatFit(constraints.maxHeight);
        final pageSize = _pageSize > capacity ? capacity : _pageSize;
        final pageCount = (_rows.length / pageSize)
            .ceil()
            .clamp(1, 1 << 31)
            .toInt();
        final currentPage = _page > pageCount ? pageCount : _page;
        final start = (currentPage - 1) * pageSize;
        final visibleRows = _rows.skip(start).take(pageSize).toList();
        final showPagination = _rows.length > pageSize;
        final pageSizes = <int>{
          if (capacity >= 4) 4,
          if (capacity >= 8) 8,
          capacity,
        }.toList()..sort();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.v32px2remSpacing07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your collections',
                      style: TypeScale.heading01.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CButton(
                    label: 'New collection',
                    icon: const Icon(Icons.add, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: Spacing.v24px15remSpacing06),
              LayoutBuilder(
                builder: (context, tableConstraints) {
                  final width = tableConstraints.maxWidth.isFinite
                      ? tableConstraints.maxWidth
                      : 720.0;
                  return CDataTable(
                    props: CDataTableProps(
                      title: 'Collections',
                      description:
                          'Requests and environments in this workspace.',
                      columns: _columns(width),
                      rows: visibleRows,
                      onRowTap: (_) {},
                    ),
                  );
                },
              ),
              if (showPagination) ...[
                const SizedBox(height: Spacing.v16px1remSpacing05),
                CPagination(
                  props: CPaginationProps(
                    totalItems: _rows.length,
                    initialPage: currentPage,
                    pageSize: pageSize,
                    pageSizes: pageSizes,
                    showPageSizeSelector: pageSizes.length > 1,
                    onPageChanged: (page) => setState(() => _page = page),
                    onPageSizeChanged: (size) => setState(() {
                      _pageSize = size;
                      _page = 1;
                    }),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
