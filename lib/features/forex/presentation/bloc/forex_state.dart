import 'package:equatable/equatable.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';

abstract class ForexState extends Equatable {
  const ForexState();

  @override
  List<Object> get props => [];
}

class ForexInitial extends ForexState {}

class ForexLoading extends ForexState {}

class ForexLoaded extends ForexState {
  final List<ForexInstrument> instruments;

  const ForexLoaded({required this.instruments});

  @override
  List<Object> get props => [instruments];
}

class ForexError extends ForexState {
  final String message;

  const ForexError({required this.message});

  @override
  List<Object> get props => [message];
}

class ForexPriceUpdate extends ForexState {
  final String symbol;
  final double price;

  const ForexPriceUpdate({required this.symbol, required this.price});

  @override
  List<Object> get props => [symbol, price];
}

class ForexSearchResult extends ForexState {
  final List<ForexInstrument> searchResults;

  const ForexSearchResult({required this.searchResults});

  @override
  List<Object> get props => [searchResults];
}
