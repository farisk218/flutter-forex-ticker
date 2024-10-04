import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_trading_app/features/forex/domain/usecases/get_forex_instruments.dart';
import 'package:flutter_trading_app/features/forex/domain/usecases/get_real_time_price.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/usecase.dart';
import 'forex_event.dart';
import 'forex_state.dart';

class ForexBloc extends Bloc<ForexEvent, ForexState> {
  final GetForexInstruments getForexInstruments;
  final GetRealTimePrice getRealTimePrice;
  StreamSubscription? _priceSubscription;
  final int maxSymbolSubscriptions = 10;
  List<String> _allSymbols = [];
  int _currentSymbolIndex = 0;
  Timer? _rotationTimer;

  ForexBloc({
    required this.getForexInstruments,
    required this.getRealTimePrice,
  }) : super(ForexInitial()) {
    on<LoadForexInstruments>(_onLoadForexInstruments, transformer: droppable());
    on<SubscribeToRealTimeUpdates>(_onSubscribeToRealTimeUpdates);
    on<UnsubscribeFromRealTimeUpdates>(_onUnsubscribeFromRealTimeUpdates);
    on<UpdateForexPrice>(_onUpdateForexPrice, transformer: restartable());
    on<SearchForexInstruments>(_onSearchForexInstruments,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 300))
            .switchMap(mapper));
    on<RotateSubscriptions>(_onRotateSubscriptions);
  }

  Future<void> _onLoadForexInstruments(
      LoadForexInstruments event, Emitter<ForexState> emit) async {
    emit(ForexLoading());
    final result = await getForexInstruments(NoParams());
    result.fold(
      (failure) => emit(ForexError(message: failure.toString())),
      (instruments) {
        _allSymbols = instruments.map((i) => i.symbol).toList();
        emit(ForexLoaded(instruments: instruments));
        _subscribeToNextBatch();
      },
    );
  }

  void _subscribeToNextBatch() {
    final endIndex = (_currentSymbolIndex + maxSymbolSubscriptions)
        .clamp(0, _allSymbols.length);
    final symbolsToSubscribe =
        _allSymbols.sublist(_currentSymbolIndex, endIndex);
    add(SubscribeToRealTimeUpdates(symbolsToSubscribe));
    _currentSymbolIndex = endIndex % _allSymbols.length;

    // Schedule next rotation
    _rotationTimer?.cancel();
    _rotationTimer =
        Timer(Duration(minutes: 1), () => add(RotateSubscriptions()));
  }

  void _onSubscribeToRealTimeUpdates(
      SubscribeToRealTimeUpdates event, Emitter<ForexState> emit) {
    _priceSubscription?.cancel();
    try {
      _priceSubscription = getRealTimePrice(event.symbols).listen(
        (priceUpdate) => add(UpdateForexPrice(
            symbol: priceUpdate.symbol, price: priceUpdate.price)),
        onError: (error) {
          emit(ForexError(message: error.toString()));
          _subscribeToNextBatch(); // Try to resubscribe on error
        },
        cancelOnError: false,
      );
    } catch (e) {
      emit(ForexError(message: 'Failed to subscribe: ${e.toString()}'));
      _subscribeToNextBatch(); // Try to resubscribe on error
    }
  }

  void _onUnsubscribeFromRealTimeUpdates(
      UnsubscribeFromRealTimeUpdates event, Emitter<ForexState> emit) {
    _priceSubscription?.cancel();
    _priceSubscription = null;
  }

  void _onUpdateForexPrice(UpdateForexPrice event, Emitter<ForexState> emit) {
    if (state is ForexLoaded) {
      final currentState = state as ForexLoaded;
      final updatedInstruments = currentState.instruments
          .map((instrument) => instrument.symbol == event.symbol
              ? instrument.copyWith(price: event.price)
              : instrument)
          .toList();
      emit(ForexLoaded(instruments: updatedInstruments));
    }
  }

  void _onSearchForexInstruments(
      SearchForexInstruments event, Emitter<ForexState> emit) {
    if (state is ForexLoaded) {
      final currentState = state as ForexLoaded;
      final searchResults = currentState.instruments
          .where((instrument) => instrument.symbol
              .toLowerCase()
              .contains(event.query.toLowerCase()))
          .toList();
      emit(ForexSearchResult(searchResults: searchResults));
    }
  }

  void _onRotateSubscriptions(
      RotateSubscriptions event, Emitter<ForexState> emit) {
    _subscribeToNextBatch();
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    _rotationTimer?.cancel();
    return super.close();
  }
}
