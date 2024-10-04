import 'package:equatable/equatable.dart';

class ForexInstrument extends Equatable {
  final String description;
  final String displaySymbol;
  final String symbol;
  final double price;

  const ForexInstrument({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
    this.price = 0.0, // Default to 0.0 if not provided
  });

  @override
  List<Object> get props => [description, displaySymbol, symbol, price];

  ForexInstrument copyWith({
    String? description,
    String? displaySymbol,
    String? symbol,
    double? price,
  }) {
    return ForexInstrument(
      description: description ?? this.description,
      displaySymbol: displaySymbol ?? this.displaySymbol,
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
    );
  }
}