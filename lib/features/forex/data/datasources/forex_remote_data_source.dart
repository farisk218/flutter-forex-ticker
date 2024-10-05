import 'package:flutter_trading_app/features/forex/data/models/forex_instrument_model.dart';
import 'package:flutter_trading_app/features/forex/data/models/quote_model.dart';

abstract class ForexRemoteDataSource {
  Future<List<ForexInstrumentModel>> getForexInstruments();
  Future<List<QuoteModel>> getLastPrice(String symbol);
}
