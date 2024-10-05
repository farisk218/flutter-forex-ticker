import 'package:equatable/equatable.dart';

class ForexInstrument extends Equatable {
  final String description;
  final String displaySymbol;
  final String symbol;
  final double price;
  final double lastPrice;

  const ForexInstrument({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
    required this.price,
    required this.lastPrice,
  });

  @override
  List<Object> get props =>
      [description, displaySymbol, symbol, price, lastPrice];

  ForexInstrument copyWith({
    String? description,
    String? displaySymbol,
    String? symbol,
    double? price,
    double? lastPrice,
  }) {
    return ForexInstrument(
      description: description ?? this.description,
      displaySymbol: displaySymbol ?? this.displaySymbol,
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      lastPrice: lastPrice ?? this.lastPrice,
    );
  }
}
