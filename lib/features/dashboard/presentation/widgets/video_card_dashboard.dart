import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_studio_widgets.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';

class VideoCardDashboard extends StatefulWidget {
  final VideoEntity video;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const VideoCardDashboard({
    super.key,
    required this.video,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<VideoCardDashboard> createState() => _VideoCardDashboardState();
}

class _VideoCardDashboardState extends State<VideoCardDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fileSizeMB =
        (widget.video.fileSize / (1024 * 1024)).toStringAsFixed(1);
    final formattedDate =
        DateFormat('MMM d, yyyy').format(widget.video.createdAt);

    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hoverController.isCompleted
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                      alpha: 0.04 + 0.04 * _elevationAnimation.value),
                  blurRadius: 4 + 8 * _elevationAnimation.value,
                  offset: Offset(0, 2 + 4 * _elevationAnimation.value),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thumbnail
                RepaintBoundary(
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          color: AppColors.thumbnailBg,
                        ),
                        child: widget.video.thumbnailUrl != null &&
                                widget.video.thumbnailUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  widget.video.thumbnailUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _buildThumbnailPlaceholder(),
                                ),
                              )
                            : _buildThumbnailPlaceholder(),
                      ),
                      // Duration/size badge
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$fileSizeMB MB',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Play overlay on hover
                      if (_hoverController.isCompleted)
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget.onTap,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  color: Colors.black.withValues(alpha: 0.1),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    color: AppColors.primary,
                                    size: 52,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.video.fileName.isEmpty
                            ? 'Untitled Video'
                            : widget.video.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fileSizeMB,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.borderLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Format badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.video_file,
                                    size: 11, color: AppColors.primary),
                                const SizedBox(width: 3),
                                Text(
                                  widget.video.format.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Actions
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ActionButton(
                                icon: Icons.play_arrow_rounded,
                                color: AppColors.primary,
                                size: 16,
                                onTap: widget.onTap,
                              ),
                              const SizedBox(width: 4),
                              _ActionButton(
                                icon: Icons.delete_outline,
                                color: AppColors.danger,
                                size: 14,
                                onTap: widget.onDelete,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return Center(
      child: Icon(
        Icons.video_library_rounded,
        size: 48,
        color: AppColors.textMuted.withValues(alpha: 0.4),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    this.size = 14,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}
