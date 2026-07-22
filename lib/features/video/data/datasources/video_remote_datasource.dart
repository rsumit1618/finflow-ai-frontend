import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:finflow_app/core/common/network/constants/api_constants.dart';
import 'package:finflow_app/core/common/business/errors/exceptions.dart';
import 'package:finflow_app/core/common/models/file_upload_model.dart';
import 'package:finflow_app/features/video/data/models/video_response.dart';

abstract class VideoRemoteDataSource {
  Future<VideoResponse> getVideos({int page = 1, int limit = 10});
  Future<Video> getVideo(String id);
  Future<VideoResponse> uploadVideos(List<FileUploadModel> videos,
      {void Function(int, int)? onProgress});
  Future<void> deleteVideo(String id);
  Future<String> uploadThumbnail(String id, FileUploadModel thumbnail);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final Dio dio;

  VideoRemoteDataSourceImpl({required this.dio});

  @override
  Future<VideoResponse> getVideos({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        ApiConstants.videos,
        queryParameters: {'page': page, 'limit': limit},
      );
      return VideoResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<Video> getVideo(String id) async {
    try {
      final response = await dio.get(ApiConstants.videoById(id));
      if (response.data['success'] == true) {
        return Video.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to get video');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server Error');
    }
  }

  @override
  Future<VideoResponse> uploadVideos(List<FileUploadModel> videos,
      {void Function(int, int)? onProgress}) async {
    try {
      final List<MultipartFile> videoFiles = [];
      for (var video in videos) {
        if (video.bytes != null) {
          // Web Upload
          videoFiles.add(MultipartFile.fromBytes(
            video.bytes!,
            filename: video.name,
            contentType: MediaType('video', video.format.replaceAll('.', '')),
          ));
        } else if (video.path != null) {
          // Mobile Upload
          videoFiles.add(await MultipartFile.fromFile(
            video.path!,
            filename: video.name,
            contentType: MediaType('video', video.format.replaceAll('.', '')),
          ));
        }
      }

      final formData = FormData.fromMap({
        'videos': videoFiles,
      });

      final response = await dio.post(
        ApiConstants.videos,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Accept': 'application/json',
          },
        ),
        onSendProgress: onProgress,
      );
      return VideoResponse.fromJson(response.data as Map<String, dynamic>);
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
  Future<String> uploadThumbnail(String id, FileUploadModel thumbnail) async {
    try {
      final MultipartFile file;
      final mediaType =
          MediaType('image', thumbnail.format.replaceAll('.', ''));

      if (thumbnail.bytes != null) {
        file = MultipartFile.fromBytes(
          thumbnail.bytes!,
          filename: thumbnail.name,
          contentType: mediaType,
        );
      } else {
        file = await MultipartFile.fromFile(
          thumbnail.path!,
          filename: thumbnail.name,
          contentType: mediaType,
        );
      }

      final formData = FormData.fromMap({
        'thumbnail': file,
      });

      final response = await dio.post(
        ApiConstants.videoThumbnail(id),
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
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
