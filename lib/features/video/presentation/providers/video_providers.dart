import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/di/injection_container.dart';
import 'package:finflow_app/features/video/data/datasources/video_remote_datasource.dart';
import 'package:finflow_app/features/video/data/repositories/video_repository_impl.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';
import 'package:finflow_app/features/video/domain/usecases/delete_video_usecase.dart';
import 'package:finflow_app/features/video/domain/usecases/get_videos_usecase.dart';
import 'package:finflow_app/features/video/domain/usecases/upload_videos_usecase.dart';
import 'package:finflow_app/features/video/presentation/providers/video_notifier.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';

final videoRemoteDataSourceProvider = Provider<VideoRemoteDataSource>((ref) {
  return VideoRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepositoryImpl(
      remoteDataSource: ref.watch(videoRemoteDataSourceProvider));
});

final getVideosUseCaseProvider = Provider<GetVideosUseCase>((ref) {
  return GetVideosUseCase(ref.watch(videoRepositoryProvider));
});

final uploadVideosUseCaseProvider = Provider<UploadVideosUseCase>((ref) {
  return UploadVideosUseCase(ref.watch(videoRepositoryProvider));
});

final deleteVideoUseCaseProvider = Provider<DeleteVideoUseCase>((ref) {
  return DeleteVideoUseCase(ref.watch(videoRepositoryProvider));
});

final videoNotifierProvider =
    StateNotifierProvider<VideoNotifier, VideoState>((ref) {
  return VideoNotifier(
    getVideosUseCase: ref.watch(getVideosUseCaseProvider),
    uploadVideosUseCase: ref.watch(uploadVideosUseCaseProvider),
    deleteVideoUseCase: ref.watch(deleteVideoUseCaseProvider),
  );
});
