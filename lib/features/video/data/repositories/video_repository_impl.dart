import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/exceptions.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/features/video/data/datasources/video_remote_datasource.dart';
import 'package:finflow_app/features/video/domain/entities/video_entity.dart';
import 'package:finflow_app/features/video/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VideoEntity>>> getVideos(
      {int page = 1, int limit = 10}) async {
    try {
      final models = await remoteDataSource.getVideos(page: page, limit: limit);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoEntity>> getVideo(String id) async {
    try {
      final model = await remoteDataSource.getVideo(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> uploadVideos(
      List<File> videos) async {
    try {
      final models = await remoteDataSource.uploadVideos(videos);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
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
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadThumbnail(
      String id, File thumbnail) async {
    try {
      final thumbnailUrl =
          await remoteDataSource.uploadThumbnail(id, thumbnail);
      return Right(thumbnailUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
