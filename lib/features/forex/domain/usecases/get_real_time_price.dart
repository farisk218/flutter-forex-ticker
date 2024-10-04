import 'dart:convert';

import 'package:flutter_trading_app/core/constants/app_urls.dart';
import 'package:flutter_trading_app/core/network/socket_service/websocket_service.dart';

import '../entities/price_update.dart';

class GetRealTimePrice {
  final WebSocketService _webSocketService;

  GetRealTimePrice(this._webSocketService);

  Stream<PriceUpdate> call(List<String> symbols) {
    final stream = _webSocketService.connect(ApiConstants.websocketUrl);

    for (final symbol in symbols) {
      _webSocketService
          .sendMessage(json.encode({"type": "subscribe", "symbol": symbol}));
    }

    return stream.map((data) => PriceUpdate(
          symbol: data['symbol'],
          price: data['price'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
        ));
  }
}
