import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeWebHeader extends StatelessWidget {
  const HomeWebHeader({
    super.key,
    required this.search,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  final String search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'countries_list.title'.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(16),
          SizedBox(
            width: 280,
            child: SearchBar(
              hintText: 'countries_list.search_hint'.tr(),
              leading: const Icon(Icons.search),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          const Gap(8),
          IconButton.outlined(
            tooltip: 'countries_list.refresh'.tr(),
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
