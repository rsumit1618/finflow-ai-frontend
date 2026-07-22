import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:finflow_app/core/common/models/file_upload_model.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/usecases/get_videos_usecase.dart';
import 'package:finflow_app/features/video/domain/usecases/upload_videos_usecase.dart';
import 'package:finflow_app/features/video/domain/usecases/delete_video_usecase.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';

class VideoNotifier extends StateNotifier<VideoState> {
  final GetVideosUseCase getVideosUseCase;
  final UploadVideosUseCase uploadVideosUseCase;
  final DeleteVideoUseCase deleteVideoUseCase;

  final _videosSubject = BehaviorSubject<List<VideoEntity>>.seeded([]);
  int _currentPage = 1;

  VideoNotifier({
    required this.getVideosUseCase,
    required this.uploadVideosUseCase,
    required this.deleteVideoUseCase,
  }) : super(VideoInitial()) {
    _videosSubject.listen((videos) {
      if (state is VideoLoaded) {
        state = VideoLoaded(
            videos: videos, hasMore: (state as VideoLoaded).hasMore);
      }
    });
  }

  Stream<List<VideoEntity>> get videosStream => _videosSubject.stream;

  Future<void> fetchVideos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      state = VideoLoading();
    }

    final result =
        await getVideosUseCase(GetVideosParams(page: _currentPage, limit: 10));

    result.fold(
      (failure) => state = VideoError(failure.message),
      (newVideos) {
        if (refresh) {
          _videosSubject.add(newVideos);
          state =
              VideoLoaded(videos: newVideos, hasMore: newVideos.length >= 10);
        } else {
          final currentVideos = _videosSubject.value;
          final updatedVideos = [...currentVideos, ...newVideos];
          _videosSubject.add(updatedVideos);
          state = VideoLoaded(
            videos: updatedVideos,
            hasMore: newVideos.length >= 10,
          );
        }
        _currentPage++;
      },
    );
  }

  Future<void> uploadVideos(List<FileUploadModel> files) async {
    state = VideoUploading();
    final result = await uploadVideosUseCase(UploadVideosParams(
      files: files,
      onProgress: (sent, total) {
        if (total > 0) {
          final progress = sent / total;
          state = VideoUploadProgress(
            progress: progress.clamp(0.0, 1.0),
            statusText: 'Uploading ${(progress * 100).toStringAsFixed(0)}%',
          );
        }
      },
    ));
    result.fold(
      (failure) => state = VideoError(failure.message),
      (uploadedVideos) {
        state = VideoUploadSuccess(uploadedVideos);
        fetchVideos(refresh: true);
      },
    );
  }

  Future<void> deleteVideo(String id) async {
    final result = await deleteVideoUseCase(id);
    result.fold(
      (failure) => state = VideoError(failure.message),
      (_) {
        final updatedVideos =
            _videosSubject.value.where((v) => v.id != id).toList();
        _videosSubject.add(updatedVideos);
      },
    );
  }

  @override
  void dispose() {
    _videosSubject.close();
    super.dispose();
  }
}
