import 'package:equatable/equatable.dart';

enum FailureType { network, server, cache, validation, unknown }

abstract class Failure extends Equatable {
  final String message;
  final FailureType type;

  const Failure(this.message, {this.type = FailureType.unknown});

  @override
  List<Object> get props => [message, type];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message) : super(type: FailureType.server);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message) : super(type: FailureType.cache);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']) : super(type: FailureType.network);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(type: FailureType.validation);
}
