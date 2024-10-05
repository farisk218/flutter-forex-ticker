import 'package:dartz/dartz.dart';
import 'package:flutter_trading_app/core/error/failures.dart';
import 'package:flutter_trading_app/core/usecase.dart';
import '../entities/last_price.dart';
import '../repositories/forex_repository.dart';

class GetLastPrice implements UseCase<List<Quote>, String> {
  final ForexRepository repository;

  GetLastPrice(this.repository);

  @override
  Future<Either<Failure, List<Quote>>> call(String symbol) async {
    return await repository.getLastPrice(symbol);
  }
}
