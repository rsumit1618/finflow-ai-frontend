import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:finflow_app/core/common/business/errors/exceptions.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/models/file_upload_model.dart';
import 'package:finflow_app/features/video/data/models/video_response.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';
import 'package:finflow_app/features/video/data/datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl({required this.remoteDataSource});

  Failure _handleDioError(DioException e) {
    if (e.response != null) {
      final message = e.response?.data?['message'] ?? 'Server Error';
      switch (e.response?.statusCode) {
        case 400:
          return ServerFailure('Validation Error: $message');
        case 401:
          return const ServerFailure('Unauthorized: Please login again.');
        case 429:
          return const ServerFailure(
              'Too many requests. Please try again later.');
        default:
          return ServerFailure(message);
      }
    }
    return const NetworkFailure('No Internet Connection');
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> getVideos(
      {int page = 1, int limit = 10}) async {
    try {
      final response =
          await remoteDataSource.getVideos(page: page, limit: limit);
      if (response.success) {
        return Right(
            response.data.videos.map((v) => _mapModelToEntity(v)).toList());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoEntity>> getVideo(String id) async {
    try {
      final model = await remoteDataSource.getVideo(id);
      return Right(_mapModelToEntity(model));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> uploadVideos(
      List<FileUploadModel> videos,
      {void Function(int, int)? onProgress}) async {
    try {
      final response =
          await remoteDataSource.uploadVideos(videos, onProgress: onProgress);
      if (response.success) {
        return Right(
            response.data.videos.map((v) => _mapModelToEntity(v)).toList());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVideo(String id) async {
    try {
      await remoteDataSource.deleteVideo(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadThumbnail(
      String id, FileUploadModel thumbnail) async {
    try {
      final thumbnailUrl =
          await remoteDataSource.uploadThumbnail(id, thumbnail);
      return Right(thumbnailUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  VideoEntity _mapModelToEntity(Video model) {
    return VideoEntity(
      id: model.id,
      fileName: model.fileName,
      fileSize: model.fileSize,
      mimeType: model.mimeType,
      format: model.format,
      url: model.url,
      thumbnailUrl: model.thumbnailUrl,
      createdAt: model.createdAt,
    );
  }
}
