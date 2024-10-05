import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:developer';

class WebSocketService {
  WebSocketChannel? _channel;
  final String url;
  void Function(dynamic) onData;
  final void Function(dynamic) onError;
  Timer? _pingTimer;
  bool _isConnected = false;

  WebSocketService({
    required this.url,
    required this.onData,
    required this.onError,
  });

  void setOnData(Function(dynamic) onDataCallback) {
    onData = onDataCallback;
  }

  void connect() {
    if (_isConnected) {
      log('WebSocket is already connected.');
      return;
    }

    try {
      log('Connecting to WebSocket: $url');
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;

      _channel!.stream.listen(
        (data) {
          log('Received data: $data');
          onData(json.decode(data));
        },
        onError: (error) {
          log('WebSocket error: $error');
          _isConnected = false;
          onError(error);
          _reconnect();
        },
        onDone: () {
          log('WebSocket connection closed.');
          _isConnected = false;
          _reconnect();
        },
      );

      _startPingTimer();
    } catch (e) {
      log('Failed to connect: $e');
      onError(e);
      _reconnect();
    }
  }

  void sendMessage(String message) {
    if (_isConnected && _channel != null) {
      log('Sending message: $message');
      _channel!.sink.add(message);
    } else {
      log('Failed to send message. WebSocket is not connected.');
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    log('Starting ping timer...');
    _pingTimer = Timer.periodic(Duration(seconds: 30), (_) {
      sendMessage(json.encode({"type": "ping"}));
      log('Ping message sent to keep the connection alive.');
    });
  }

  void _reconnect() {
    log('Attempting to reconnect in 5 seconds...');
    Future.delayed(Duration(seconds: 5), () {
      if (!_isConnected) {
        log('Reconnecting to WebSocket...');
        connect(); // Try reconnecting
      }
    });
  }

  void dispose() {
    log('Disposing WebSocketService...');
    _pingTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }
}
