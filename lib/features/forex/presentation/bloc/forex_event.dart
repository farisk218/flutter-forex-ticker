import 'package:equatable/equatable.dart';

abstract class ForexEvent extends Equatable {
  const ForexEvent();

  @override
  List<Object?> get props => [];
}

class LoadForexInstruments extends ForexEvent {}

class SubscribeToRealTimeUpdates extends ForexEvent {
  final List<String> symbols;

  const SubscribeToRealTimeUpdates(this.symbols);

  @override
  List<Object?> get props => [symbols];
}

class UnsubscribeFromRealTimeUpdates extends ForexEvent {}

class UpdateForexPrice extends ForexEvent {
  final String symbol;
  final double price;

  const UpdateForexPrice({
    required this.symbol,
    required this.price,
  });

  @override
  List<Object?> get props => [symbol, price, ];
}

class SearchForexInstruments extends ForexEvent {
  final String query;

  const SearchForexInstruments(this.query);

  @override
  List<Object?> get props => [query];
}

class RotateSubscriptions extends ForexEvent {}
