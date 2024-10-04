import 'package:flutter_trading_app/features/forex/data/models/forex_instrument_model.dart';

abstract class ForexRemoteDataSource {
  Future<List<ForexInstrumentModel>> getForexInstruments();
}
