class PriceUpdate {
  final String symbol;
  final double price;
  final DateTime timestamp;

  PriceUpdate({required this.symbol, required this.price, required this.timestamp});
}