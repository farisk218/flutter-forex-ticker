import 'package:dartz/dartz.dart';
import 'package:flutter_trading_app/core/error/failures.dart';
import '../entities/forex_instrument.dart';

abstract class ForexRepository {
  Future<Either<Failure, List<ForexInstrument>>> getForexInstruments();
}
