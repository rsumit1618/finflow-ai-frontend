import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_studio_widgets.dart';

class AccessNote extends StatelessWidget {
  const AccessNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              l10n?.translate('access_note_text') ??
                  'Public and Subscribers can watch all videos · privacy settings are shown on each card',
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.shield_outlined, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}
