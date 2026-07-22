import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';

class YoutubeVideoCard extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isGrid;

  const YoutubeVideoCard({
    super.key,
    required this.video,
    required this.onTap,
    required this.onDelete,
    this.isGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return isGrid ? _buildGridCard(context) : _buildListCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    final formattedDate = DateFormat('MMM d, yyyy').format(video.createdAt);
    final fileSizeMB = (video.fileSize / (1024 * 1024)).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey.shade200,
                    child: video.thumbnailUrl != null &&
                            video.thumbnailUrl!.isNotEmpty
                        ? Image.network(
                            video.thumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildThumbnailPlaceholder(),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            },
                          )
                        : _buildThumbnailPlaceholder(),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                  // Play button overlay
                  Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  ),
                  // Duration badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fileSizeMB == '0.0' ? '--:--' : '${fileSizeMB}MB',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Material tap effect
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        splashColor: Colors.black12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Video info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  video.fileName.isEmpty ? 'Untitled Video' : video.fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Meta info row
                Row(
                  children: [
                    _buildMetaChip(video.format.toUpperCase(), Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Delete button
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final formattedDate = DateFormat('MMM d, yyyy').format(video.createdAt);
    final fileSizeMB = (video.fileSize / (1024 * 1024)).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 68,
                        color: Colors.grey.shade200,
                        child: video.thumbnailUrl != null &&
                                video.thumbnailUrl!.isNotEmpty
                            ? Image.network(
                                video.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildThumbnailPlaceholder(),
                              )
                            : _buildThumbnailPlaceholder(),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.fileName.isEmpty
                            ? 'Untitled Video'
                            : video.fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildMetaChip(
                              video.format.toUpperCase(), Colors.blue),
                          const SizedBox(width: 6),
                          Text(
                            fileSizeMB,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 11),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.red.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.video_library_rounded,
          size: 40,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildMetaChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
