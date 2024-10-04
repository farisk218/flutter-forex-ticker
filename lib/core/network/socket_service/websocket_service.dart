import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

abstract class WebSocketService {
  Stream<Map<String, dynamic>> connect(String url);
  void sendMessage(String message);
  void dispose();
}

class ForexWebSocketService implements WebSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _streamController;
  bool _isDisposed = false;

  @override
  Stream<Map<String, dynamic>> connect(String url) {
    _streamController = StreamController<Map<String, dynamic>>.broadcast();
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (message) {
        if (!_isDisposed) {
          final data = json.decode(message);
          if (data['type'] == 'trade') {
            for (var trade in data['data']) {
              _streamController?.add({
                'symbol': trade['s'],
                'price': trade['p'],
                'timestamp': trade['t'],
              });
            }
          } else if (data['type'] == 'error') {
            _streamController?.addError(data['msg']);
          }
        }
      },
      onError: (error) {
        if (!_isDisposed) _streamController?.addError(error.toString());
      },
      onDone: () {
        if (!_isDisposed) _streamController?.close();
      },
    );

    return _streamController!.stream;
  }

  @override
  void sendMessage(String message) {
    if (!_isDisposed) _channel?.sink.add(message);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _channel?.sink.close();
    _streamController?.close();
  }
}
