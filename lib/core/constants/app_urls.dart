class ApiConstants {
  static const String baseUrl = 'https://finnhub.io/api/v1';
  static const String apiKey = 'crvon11r01qkji45n6r0crvon11r01qkji45n6rg';

  static String get forexSymbols =>
      '$baseUrl/forex/symbol?exchange=oanda&token=$apiKey';
  static String get websocketUrl => 'wss://ws.finnhub.io?token=$apiKey';
}
