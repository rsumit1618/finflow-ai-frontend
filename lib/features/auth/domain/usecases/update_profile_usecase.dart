import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/business/usecases/usecase.dart';
import 'package:finflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:finflow_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      age: params.age,
      college: params.college,
      qualificationYear: params.qualificationYear,
      address: params.address,
      highestQualification: params.highestQualification,
      profileImage: params.profileImage,
    );
  }
}

class UpdateProfileParams {
  final String firstName;
  final String lastName;
  final int age;
  final String college;
  final int qualificationYear;
  final String address;
  final String highestQualification;
  final String? profileImage;

  UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.college,
    required this.qualificationYear,
    required this.address,
    required this.highestQualification,
    this.profileImage,
  });
}
