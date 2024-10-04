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
    required this.price,
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