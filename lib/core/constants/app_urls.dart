class ApiConstants {
  static const String baseUrl = 'https://finnhub.io/api/v1';
  static const String apiKey = 'cs0fdspr01qrbtrlbpd0cs0fdspr01qrbtrlbpdg';

  static String get forexSymbols =>
      '$baseUrl/forex/symbol?exchange=oanda&token=$apiKey';
  static String get websocketUrl => 'wss://ws.finnhub.io?token=$apiKey';
}
