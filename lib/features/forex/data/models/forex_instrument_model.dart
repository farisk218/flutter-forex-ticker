import 'package:flutter_trading_app/core/network/http_service/base_model.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';

class ForexInstrumentModel extends ForexInstrument
    implements BaseModel<ForexInstrumentModel> {
  ForexInstrumentModel({
    required String description,
    required String displaySymbol,
    required String symbol,
    double price = 0.0,
  }) : super(
          description: description,
          displaySymbol: displaySymbol,
          symbol: symbol,
          price: price,
        );

  @override
  ForexInstrumentModel fromJson(Map<String, dynamic> json) {
    return ForexInstrumentModel.fromJsonFactory(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'displaySymbol': displaySymbol,
      'symbol': symbol,
      'price': price,
    };
  }

  static ForexInstrumentModel fromJsonFactory(Map<String, dynamic> json) {
    return ForexInstrumentModel(
      description: json['description'] ?? '',
      displaySymbol: json['displaySymbol'] ?? '',
      symbol: json['symbol'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory ForexInstrumentModel.empty() {
    return ForexInstrumentModel(
      description: '',
      displaySymbol: '',
      symbol: '',
      price: 0.0,
    );
  }
}
