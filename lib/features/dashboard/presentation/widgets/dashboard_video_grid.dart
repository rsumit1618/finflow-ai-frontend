import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/features/video/presentation/screens/video_player_screen.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';
import 'package:finflow_app/core/common/ui/utils/error_handler_ui.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_studio_widgets.dart';
import 'package:finflow_app/features/video/presentation/providers/video_providers.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/video_card_dashboard.dart';

class DashboardVideoGrid extends ConsumerStatefulWidget {
  final double maxWidth;

  const DashboardVideoGrid({super.key, required this.maxWidth});

  @override
  ConsumerState<DashboardVideoGrid> createState() => _DashboardVideoGridState();
}

class _DashboardVideoGridState extends ConsumerState<DashboardVideoGrid> {
  void _playVideo(VideoEntity video) {
    if (video.url.isEmpty) {
      ErrorHandlerUI.showError(context, 'Video URL not available');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(video: video),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete video?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will remove the video from your library.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(videoNotifierProvider.notifier).deleteVideo(id);
              Navigator.pop(context);
            },
            child:
                const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoNotifierProvider);
    final l10n = AppLocalizations.of(context);
    final crossAxisCount = _getCrossAxisCount(widget.maxWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.table_rows_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  l10n?.translate('all_videos') ?? 'All videos',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    l10n?.translate('filter') ?? 'Filter',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Video grid
        _buildVideoGrid(videoState, crossAxisCount),
      ],
    );
  }

  Widget _buildVideoGrid(VideoState state, int crossAxisCount) {
    if (state is VideoLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<VideoEntity> videos = [];
    if (state is VideoLoaded) {
      videos = state.videos;
    }

    if (videos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.video_library_outlined,
                  size: 60, color: AppColors.textMuted.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                'No videos yet',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your first video to get started',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: widget.maxWidth > 800 ? 1.4 : 1.0,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCardDashboard(
          video: video,
          onTap: () => _playVideo(video),
          onDelete: () => _confirmDelete(video.id),
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 750) return 2;
    return 1;
  }
}
