import 'package:flutter/material.dart';

import '../../../core/carbon.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.v32px2remSpacing07),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pick up from where you left off',
                      style: TypeScale.heading01.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Flexible(
                    child: CContentSwitcher(
                      props: CContentSwitcherProps(
                        size: CContentSwitcherSize.sm,
                        options: [
                          CContentSwitcherOption(label: 'Recent'),
                          CContentSwitcherOption(label: 'Favorites'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.v8px05remSpacing03),
              CContainedList(
                props: CContainedListProps(
                  items: [
                    CContainedListItem(
                      label: 'Latest request',
                      description: 'Continue where you left off',
                      icon: const Icon(Icons.bolt),
                      onTap: () {},
                    ),
                    CContainedListItem(
                      label: 'Sample collection',
                      description: 'Imported 2 hours ago',
                      icon: const Icon(Icons.folder),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
