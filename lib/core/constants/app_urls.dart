import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://finnhub.io/api/v1';

  static String get apiKey => dotenv.env['FINNHUB_API_KEY'] ?? '';

  static String get forexSymbols =>
      '$baseUrl/forex/symbol?exchange=oanda&token=$apiKey';
  static String get websocketUrl => 'wss://ws.finnhub.io?token=$apiKey';
}
