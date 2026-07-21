import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finflow_app/core/common/constants/api_constants.dart';
import 'package:finflow_app/core/common/errors/exceptions.dart';
import 'package:finflow_app/features/video/data/models/video_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos({int page = 1, int limit = 10});
  Future<VideoModel> getVideo(String id);
  Future<List<VideoModel>> uploadVideos(List<File> videos);
  Future<void> deleteVideo(String id);
  Future<String> uploadThumbnail(String id, File thumbnail);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final Dio dio;

  VideoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VideoModel>> getVideos({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        ApiConstants.videos,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.data['success'] == true) {
        final List videos = response.data['data']['videos'];
        return videos.map((v) => VideoModel.fromJson(v)).toList();
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to get videos');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<VideoModel> getVideo(String id) async {
    try {
      final response = await dio.get(ApiConstants.videoById(id));
      if (response.data['success'] == true) {
        return VideoModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to get video');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<List<VideoModel>> uploadVideos(List<File> videos) async {
    try {
      final formData = FormData();
      for (var file in videos) {
        formData.files.add(MapEntry(
          'videos',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      }

      final response = await dio.post(
        ApiConstants.videos,
        data: formData,
      );
      if (response.data['success'] == true) {
        final List videoList = response.data['data']['videos'];
        return videoList.map((v) => VideoModel.fromJson(v)).toList();
      } else {
        throw ServerException(response.data['message'] ?? 'Upload failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<void> deleteVideo(String id) async {
    try {
      final response = await dio.delete(ApiConstants.videoById(id));
      if (response.data['success'] != true) {
        throw ServerException(response.data['message'] ?? 'Delete failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<String> uploadThumbnail(String id, File thumbnail) async {
    try {
      final formData = FormData.fromMap({
        'thumbnail':
            await MultipartFile.fromFile(thumbnail.path, filename: 'thumb.jpg'),
      });

      final response = await dio.post(
        ApiConstants.videoThumbnail(id),
        data: formData,
      );
      if (response.data['success'] == true) {
        return response.data['data']['thumbnailUrl'];
      } else {
        throw ServerException(
            response.data['message'] ?? 'Thumbnail upload failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }
}
