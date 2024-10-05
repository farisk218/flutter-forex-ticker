import 'package:flutter_trading_app/core/network/http_service/base_model.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/last_price.dart';

class QuoteModel extends Quote implements BaseModel<QuoteModel> {
  const QuoteModel({
    required double currentPrice,
    required double timestamp,
  }) : super(
          currentPrice: currentPrice,
          timestamp: timestamp,
        );

  @override
  QuoteModel fromJson(Map<String, dynamic> json) {
    return QuoteModel.fromJsonFactory(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'c': currentPrice,
      't': timestamp,
    };
  }

  static QuoteModel fromJsonFactory(Map<String, dynamic> json) {
    return QuoteModel(
      currentPrice: (json['c'] as num).toDouble(),
      timestamp: (json['t'] as num).toDouble(),
    );
  }

  factory QuoteModel.empty() {
    return QuoteModel(
      currentPrice: 0.0,
      timestamp: 0.0,
    );
  }
}
