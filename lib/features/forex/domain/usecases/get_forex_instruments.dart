import 'package:dartz/dartz.dart';
import 'package:flutter_trading_app/core/error/failures.dart';
import 'package:flutter_trading_app/core/usecase.dart';
import '../entities/forex_instrument.dart';
import '../repositories/forex_repository.dart';

class GetForexInstruments implements UseCase<List<ForexInstrument>, NoParams> {
  final ForexRepository repository;

  GetForexInstruments(this.repository);

  @override
  Future<Either<Failure, List<ForexInstrument>>> call(NoParams params) async {
    return await repository.getForexInstruments();
  }
}
