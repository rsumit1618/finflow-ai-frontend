import 'package:flutter/material.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:intl/intl.dart';

class VideoCard extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.blue.shade50,
                        child: video.thumbnailUrl != null
                            ? Image.network(
                                video.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                    const Icon(Icons.play_circle_filled, color: Colors.white70, size: 30),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildChip(video.format.toUpperCase(), Colors.blue),
                          const SizedBox(width: 8),
                          _buildChip('${(video.fileSize / (1024 * 1024)).toStringAsFixed(1)} MB', Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM yyyy').format(video.createdAt),
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                  onPressed: onDelete,
                  tooltip: 'Delete Video',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Icon(Icons.video_library_rounded, color: Colors.blue, size: 32);
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
