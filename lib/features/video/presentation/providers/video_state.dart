import 'package:equatable/equatable.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoEntity> videos;
  final bool hasMore;

  const VideoLoaded({required this.videos, this.hasMore = true});

  @override
  List<Object?> get props => [videos, hasMore];
}

class VideoError extends VideoState {
  final String message;
  const VideoError(this.message);

  @override
  List<Object?> get props => [message];
}

class VideoUploading extends VideoState {}

class VideoUploadProgress extends VideoState {
  final double progress; // 0.0 to 1.0
  final String statusText;

  const VideoUploadProgress(
      {required this.progress, this.statusText = 'Uploading...'});

  @override
  List<Object?> get props => [progress, statusText];
}

class VideoUploadSuccess extends VideoState {
  final List<VideoEntity> uploadedVideos;
  const VideoUploadSuccess(this.uploadedVideos);

  @override
  List<Object?> get props => [uploadedVideos];
}
