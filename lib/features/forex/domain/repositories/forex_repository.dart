import 'package:dartz/dartz.dart';
import 'package:flutter_trading_app/core/error/failures.dart';
import '../entities/forex_instrument.dart';
import '../entities/last_price.dart';

abstract class ForexRepository {
  Future<Either<Failure, List<ForexInstrument>>> getForexInstruments();
  Future<Either<Failure, List<Quote>>> getLastPrice(String symbol);
}
