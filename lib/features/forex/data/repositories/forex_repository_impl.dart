import 'package:dartz/dartz.dart';
import 'package:flutter_trading_app/core/error/exceptions.dart';
import 'package:flutter_trading_app/core/error/failures.dart';
import 'package:flutter_trading_app/core/network/network_info.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/last_price.dart';
import 'package:flutter_trading_app/features/forex/domain/repositories/forex_repository.dart';
import '../datasources/forex_local_data_source.dart';
import '../datasources/forex_remote_data_source.dart';

class ForexRepositoryImpl implements ForexRepository {
  final ForexRemoteDataSource remoteDataSource;
  final ForexLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ForexRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ForexInstrument>>> getForexInstruments() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInstruments = await remoteDataSource.getForexInstruments();
        await localDataSource.cacheForexInstruments(remoteInstruments);
        return Right(remoteInstruments);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      } on BadRequestException {
        return Left(BadRequestFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on TimeoutException {
        return Left(TimeoutFailure());
      } on RequestCancelledException {
        return Left(RequestCancelledFailure());
      }
    } else {
      try {
        final localInstruments =
            await localDataSource.getLastForexInstruments();
        return Right(localInstruments);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Quote>>> getLastPrice(String symbol) async {
    if (await networkInfo.isConnected) {
      try {
        final quote = await remoteDataSource.getLastPrice(symbol);
        return Right(quote);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      } on BadRequestException {
        return Left(BadRequestFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on TimeoutException {
        return Left(TimeoutFailure());
      } on RequestCancelledException {
        return Left(RequestCancelledFailure());
      } catch (e) {
        return Left(TimeoutFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
