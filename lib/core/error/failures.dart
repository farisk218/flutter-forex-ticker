import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class BadRequestFailure extends Failure {}

class UnauthorizedFailure extends Failure {}

class NotFoundFailure extends Failure {}

class TimeoutFailure extends Failure {}

class RequestCancelledFailure extends Failure {}
