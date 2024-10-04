import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_trading_app/core/error/exceptions.dart';
import 'package:flutter_trading_app/features/forex/data/models/forex_instrument_model.dart';

abstract class ForexLocalDataSource {
  Future<List<ForexInstrumentModel>> getLastForexInstruments();
  Future<void> cacheForexInstruments(List<ForexInstrumentModel> instruments);
}

const CACHED_FOREX_INSTRUMENTS = 'CACHED_FOREX_INSTRUMENTS';

class ForexLocalDataSourceImpl implements ForexLocalDataSource {
  final SharedPreferences sharedPreferences;

  ForexLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ForexInstrumentModel>> getLastForexInstruments() {
    final jsonString = sharedPreferences.getString(CACHED_FOREX_INSTRUMENTS);
    if (jsonString != null) {
      return Future.value(json
          .decode(jsonString)
          .map<ForexInstrumentModel>(
              (json) => ForexInstrumentModel.fromJsonFactory(json))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheForexInstruments(List<ForexInstrumentModel> instruments) {
    return sharedPreferences.setString(
      CACHED_FOREX_INSTRUMENTS,
      json.encode(
          instruments.map((instrument) => instrument.toJson()).toList()),
    );
  }
}
