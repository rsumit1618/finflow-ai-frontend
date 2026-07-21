import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/video/presentation/providers/video_providers.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';
import 'package:finflow_app/features/video/presentation/widgets/video_card.dart';

class VideoListScreen extends ConsumerStatefulWidget {
  const VideoListScreen({super.key});

  @override
  ConsumerState<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends ConsumerState<VideoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(videoNotifierProvider.notifier).fetchVideos(refresh: true));
  }

  Future<void> _pickAndUploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );

    if (result != null) {
      final files = result.paths
          .where((path) => path != null)
          .map((path) => File(path!))
          .toList();
      if (files.isNotEmpty) {
        ref.read(videoNotifierProvider.notifier).uploadVideos(files);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('FinFlow AI',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.black87),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: _buildBody(videoState),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: videoState is VideoUploading ? null : _pickAndUploadFiles,
        icon: videoState is VideoUploading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.cloud_upload_outlined),
        label: Text(
            videoState is VideoUploading ? 'Uploading...' : 'Upload Video'),
      ),
    );
  }

  Widget _buildBody(VideoState state) {
    if (state is VideoLoading && state is! VideoLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is VideoError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(videoNotifierProvider.notifier)
                    .fetchVideos(refresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is VideoLoaded) {
      final videos = state.videos;
      if (videos.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No videos found',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              SizedBox(height: 8),
              Text('Upload your first video to get started',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () =>
            ref.read(videoNotifierProvider.notifier).fetchVideos(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: videos.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == videos.length) {
              ref.read(videoNotifierProvider.notifier).fetchVideos();
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator()));
            }

            final video = videos[index];
            return VideoCard(
              video: video,
              onDelete: () => _confirmDelete(video.id),
              onTap: () {
                // TODO: Open Player
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Video'),
        content: const Text(
            'Are you sure you want to permanently delete this video?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(videoNotifierProvider.notifier).deleteVideo(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
