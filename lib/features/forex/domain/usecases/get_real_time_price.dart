import 'dart:async';
import 'dart:convert';
import 'package:flutter_trading_app/core/network/socket_service/websocket_service.dart';

import '../entities/price_update.dart';

class GetRealTimePrice {
  final WebSocketService _webSocketService;
  final _controller = StreamController<PriceUpdate>.broadcast();
  final int maxSubscriptions = 50;  // Finnhub limit
  Set<String> _subscribedSymbols = {};

  GetRealTimePrice(String apiKey)
      : _webSocketService = WebSocketService(
          url: 'wss://ws.finnhub.io?token=$apiKey',
          onData: (data) {},
          onError: (error) => print('WebSocket error: $error'),
        ) {
    _webSocketService.connect();
    _webSocketService.onData = _handleWebSocketData;
  }

  void _handleWebSocketData(dynamic data) {
    if (data['type'] == 'trade') {
      for (var trade in data['data']) {
        if (_subscribedSymbols.contains(trade['s'])) {
          _controller.add(PriceUpdate(
            symbol: trade['s'],
            price: trade['p'].toDouble(),
          ));
        }
      }
    }
  }

  Stream<PriceUpdate> call(List<String> symbols) {
    final symbolsToSubscribe = symbols.take(maxSubscriptions).toSet();
    final symbolsToUnsubscribe = _subscribedSymbols.difference(symbolsToSubscribe);

    for (var symbol in symbolsToUnsubscribe) {
      _webSocketService.sendMessage(json.encode({
        "type": "unsubscribe",
        "symbol": symbol
      }));
    }

    for (var symbol in symbolsToSubscribe.difference(_subscribedSymbols)) {
      _webSocketService.sendMessage(json.encode({
        "type": "subscribe",
        "symbol": symbol
      }));
    }

    _subscribedSymbols = symbolsToSubscribe;

    return _controller.stream;
  }

  void dispose() {
    _controller.close();
    _webSocketService.dispose();
  }
}