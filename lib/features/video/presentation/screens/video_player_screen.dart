import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/di/injection_container.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_studio_widgets.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';

/// Video player that downloads the video via Dio (handles auth tokens)
/// then plays it locally. This works for ANY video format (mp4, webm, mov, avi, etc.)
class VideoPlayerScreen extends ConsumerStatefulWidget {
  final VideoEntity video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isReady = false;
  String _statusText = 'Preparing...';
  double _downloadProgress = 0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _downloadAndPlay();
  }

  Future<void> _downloadAndPlay() async {
    try {
      final dio = ref.read(dioProvider);

      // Get temp directory
      final dir = await getTemporaryDirectory();
      final ext = _getExtension(widget.video.url, widget.video.format);
      final filePath = '${dir.path}/${widget.video.id}$ext';

      setState(() => _statusText = 'Downloading video...');

      // Download with progress
      await dio.download(
        widget.video.url,
        filePath,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': '*/*',
          },
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            setState(() {
              _downloadProgress = received / total;
              _statusText =
                  'Downloading ${(received / total * 100).toStringAsFixed(0)}%';
            });
          }
        },
      );

      if (!mounted) return;

      setState(() => _statusText = 'Processing video...');

      // Initialize video player with local file
      final controller = VideoPlayerController.file(
        File(filePath),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
        ),
      );
      _controller = controller;

      await controller.initialize();

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: AppColors.border,
          bufferedColor: AppColors.borderLight,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorBuilder: (context, errorMessage) {
          return _buildError(
            'Playback Error',
            errorMessage,
          );
        },
      );

      setState(() {
        _isReady = true;
        _downloadProgress = 1.0;
        _statusText = '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  String _getExtension(String url, String format) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final path = uri.path;
      final dotIndex = path.lastIndexOf('.');
      if (dotIndex > 0) {
        return path.substring(dotIndex);
      }
    }
    return '.${format.replaceAll('.', '')}';
  }

  Widget _buildError(String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.video.fileName,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _hasError
          ? _buildError('Cannot play this video', _errorMessage)
          : !_isReady
              ? _buildDownloading()
              : _buildPlayer(),
    );
  }

  Widget _buildDownloading() {
    final fileSizeMB =
        (widget.video.fileSize / (1024 * 1024)).toStringAsFixed(1);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _downloadProgress > 0 ? _downloadProgress : null,
                      strokeWidth: 6,
                      color: AppColors.primary,
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  Text(
                    _downloadProgress > 0
                        ? '${(_downloadProgress * 100).toStringAsFixed(0)}%'
                        : '...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _statusText,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$fileSizeMB MB',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final fileSizeMB =
        (widget.video.fileSize / (1024 * 1024)).toStringAsFixed(1);
    return Column(
      children: [
        Expanded(
          child: _chewieController != null
              ? Chewie(controller: _chewieController!)
              : const SizedBox(),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.video.fileName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _chip(Icons.video_file, widget.video.format.toUpperCase()),
                  _chip(Icons.storage, '$fileSizeMB MB'),
                  if (widget.video.mimeType != null)
                    _chip(Icons.description, widget.video.mimeType!),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
