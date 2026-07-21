import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/usecases/delete_video_usecase.dart';
import 'package:finflow_app/features/video/domain/usecases/get_videos_usecase.dart';
import 'package:finflow_app/features/video/domain/usecases/upload_videos_usecase.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';

/// StateNotifier managing video list state with pagination support.
class VideoNotifier extends StateNotifier<VideoState> {
  final GetVideosUseCase getVideosUseCase;
  final UploadVideosUseCase uploadVideosUseCase;
  final DeleteVideoUseCase deleteVideoUseCase;

  int _currentPage = 1;

  VideoNotifier({
    required this.getVideosUseCase,
    required this.uploadVideosUseCase,
    required this.deleteVideoUseCase,
  }) : super(VideoInitial());

  /// Fetches videos with optional refresh (resets pagination).
  Future<void> fetchVideos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      state = VideoLoading();
    }

    final result =
        await getVideosUseCase(GetVideosParams(page: _currentPage, limit: 10));

    result.fold(
      (Failure failure) {
        state = VideoError(failure.message);
      },
      (List<VideoEntity> videos) {
        if (refresh) {
          state = VideoLoaded(videos: videos, hasMore: videos.length >= 10);
        } else {
          final currentVideos = state is VideoLoaded
              ? (state as VideoLoaded).videos
              : <VideoEntity>[];
          state = VideoLoaded(
            videos: [...currentVideos, ...videos],
            hasMore: videos.length >= 10,
          );
        }
        _currentPage++;
      },
    );
  }

  /// Uploads video files and refreshes the list on success.
  Future<void> uploadVideos(List<File> files) async {
    state = VideoUploading();
    final result = await uploadVideosUseCase(files);
    result.fold(
      (Failure failure) {
        state = VideoError(failure.message);
      },
      (List<VideoEntity> videos) {
        state = VideoUploadSuccess(videos);
        fetchVideos(refresh: true);
      },
    );
  }

  /// Deletes a video by ID and refreshes the list on success.
  Future<void> deleteVideo(String id) async {
    final result = await deleteVideoUseCase(id);
    result.fold(
      (Failure failure) {
        state = VideoError(failure.message);
      },
      (_) {
        fetchVideos(refresh: true);
      },
    );
  }
}
