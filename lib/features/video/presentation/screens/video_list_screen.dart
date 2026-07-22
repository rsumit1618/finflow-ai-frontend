import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finflow_app/core/common/utils/routing/app_router.dart';
import 'package:finflow_app/core/common/models/file_upload_model.dart';
import 'package:finflow_app/core/common/ui/utils/error_handler_ui.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/presentation/providers/video_providers.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';
import 'package:finflow_app/features/video/presentation/widgets/youtube_video_card.dart';
import 'package:flutter/foundation.dart';

class VideoListScreen extends ConsumerStatefulWidget {
  const VideoListScreen({super.key});

  @override
  ConsumerState<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends ConsumerState<VideoListScreen> {
  List<FileUploadModel> _selectedFiles = [];
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Finance',
    'Analysis',
    'Reports',
    'Recordings',
    'AI Generated',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(videoNotifierProvider.notifier).fetchVideos(refresh: true));
  }

  Future<void> _playVideo(VideoEntity video) async {
    if (video.url.isEmpty) {
      ErrorHandlerUI.showError(context, 'Video URL not available');
      return;
    }
    try {
      final uri = Uri.parse(video.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ErrorHandlerUI.showError(context, 'Could not open video player');
      }
    } catch (e) {
      ErrorHandlerUI.showError(context, 'Error opening video: $e');
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.video,
        withData: kIsWeb,
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files
              .map((f) => FileUploadModel(
                    name: f.name,
                    size: f.size,
                    path: kIsWeb ? null : f.path,
                    bytes: f.bytes,
                    format: f.extension ?? 'mp4',
                  ))
              .toList();
        });
        _showUploadDialog();
      }
    } catch (e) {
      ErrorHandlerUI.showError(context, 'Error picking files: $e');
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_rounded,
                    color: Colors.red, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Upload Videos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Review your selection before uploading.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF272727),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _selectedFiles.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 12,
                        endIndent: 12,
                        color: Color(0xFF3A3A3A),
                      ),
                      itemBuilder: (context, index) {
                        final file = _selectedFiles[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.video_file,
                              color: Colors.grey, size: 20),
                          title: Text(
                            file.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel_outlined,
                                color: Colors.redAccent, size: 18),
                            onPressed: () {
                              setDialogState(() {
                                _selectedFiles.removeAt(index);
                              });
                              setState(() {});
                              if (_selectedFiles.isEmpty) Navigator.pop(ctx);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _selectedFiles = []);
                Navigator.pop(ctx);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(videoNotifierProvider.notifier)
                    .uploadVideos(_selectedFiles);
                setState(() => _selectedFiles = []);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;
    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth > 1200
        ? 4
        : screenWidth > 900
            ? 3
            : screenWidth > 600
                ? 2
                : 1;

    ref.listen<VideoState>(videoNotifierProvider, (previous, next) {
      if (next is VideoUploadSuccess) {
        ErrorHandlerUI.showSnackBar(
          context,
          'Videos uploaded successfully!',
          isError: false,
        );
      } else if (next is VideoError) {
        if (previous is VideoUploading || previous is VideoUploadProgress) {
          ErrorHandlerUI.showError(context, 'Upload failed: ${next.message}');
        } else {
          ErrorHandlerUI.showError(context, next.message);
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: CustomScrollView(
        slivers: [
          // YouTube-style App Bar
          SliverAppBar(
            expandedHeight: 56,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0F0F0F),
            surfaceTintColor: const Color(0xFF0F0F0F),
            title: Row(
              children: [
                const Icon(Icons.play_circle_fill_rounded,
                    color: Colors.red, size: 28),
                const SizedBox(width: 6),
                const Text(
                  'FinFlow',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: Hero(
                    tag: 'profile_pic',
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade700,
                      backgroundImage: user?.profileImage != null
                          ? NetworkImage(user!.profileImage!)
                          : null,
                      child: user?.profileImage == null
                          ? Text(
                              user?.email[0].toUpperCase() ?? 'U',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Upload progress banner
          if (videoState is VideoUploading || videoState is VideoUploadProgress)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF1A1A1A),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          videoState is VideoUploadProgress
                              ? videoState.statusText
                              : 'Uploading...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (videoState is VideoUploadProgress) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: videoState.progress,
                          minHeight: 4,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation(Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Category chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = cat == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF272727),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Video Grid
          _buildVideoGrid(videoState, crossAxisCount),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: videoState is VideoUploading ? null : _pickFiles,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        child: videoState is VideoUploading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVideoGrid(VideoState state, int crossAxisCount) {
    return StreamBuilder<List<VideoEntity>>(
      stream: ref.read(videoNotifierProvider.notifier).videosStream,
      builder: (context, snapshot) {
        if (state is VideoLoading && !snapshot.hasData) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
          );
        }

        final videos = snapshot.data ?? [];

        if (videos.isEmpty) {
          return SliverFillRemaining(child: _buildEmptyState());
        }

        // Filter by category
        final filteredVideos = _selectedCategory == 'All' ? videos : videos;

        if (filteredVideos.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_off_outlined,
                      size: 60, color: Colors.grey.shade800),
                  const SizedBox(height: 16),
                  const Text(
                    'No videos in this category',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio:
                  crossAxisCount == 1 ? 16 / 9 * 1.5 : 16 / 9 * 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final video = filteredVideos[index];
                return YoutubeVideoCard(
                  video: video,
                  onTap: () => _playVideo(video),
                  onDelete: () => _confirmDelete(video.id),
                  isGrid: crossAxisCount > 1,
                );
              },
              childCount: filteredVideos.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.video_collection_outlined,
              size: 50,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No videos yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to upload your first video',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Upload Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete video?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will remove the video from your library.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ref.read(videoNotifierProvider.notifier).deleteVideo(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
