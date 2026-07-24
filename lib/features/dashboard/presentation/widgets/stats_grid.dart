import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_studio_widgets.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800 ? 2 : 1);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: crossAxisCount == 1 ? 3.5 : 2.2,
          children: [
            StatCard(
              label: l10n?.translate('total_videos') ?? 'Total videos',
              value: '48',
              change: l10n?.translate('plus_three_week') ?? '+3 this week',
            ),
            StatCard(
              label: l10n?.translate('views') ?? 'Views',
              value: '2.4M',
              change: l10n?.translate('plus_twelve_percent') ?? '+12%',
            ),
            StatCard(
              label: l10n?.translate('followers') ?? 'Followers',
              value: '14.2k',
              change: l10n?.translate('plus_two_twelve') ?? '+212',
            ),
            StatCard(
              label: l10n?.translate('engagement') ?? 'Engagement',
              value: '5.2%',
              change: l10n?.translate('stable') ?? 'stable',
              isPositive: false,
            ),
          ],
        );
      },
    );
  }
}
