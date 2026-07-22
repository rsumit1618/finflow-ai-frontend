import 'package:dartz/dartz.dart';
import 'package:finflow_app/core/common/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
