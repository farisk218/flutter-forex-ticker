import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/price_update.dart';
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
    on<SortForexInstruments>(_onSortForexInstruments);
  }

  Future<void> _onLoadForexInstruments(
      LoadForexInstruments event, Emitter<ForexState> emit) async {
    emit(ForexLoading());
    final result = await getForexInstruments(NoParams());
    if (emit.isDone) return;
    result.fold(
      (failure) => emit(ForexError(message: failure.toString())),
      (instruments) {
        _allSymbols = instruments.map((i) => i.symbol).toList();
        emit(ForexLoaded(instruments: instruments));
        // Cancel existing subscription and start a new one
        _priceSubscription?.cancel();
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

    _rotationTimer?.cancel();
    _rotationTimer =
        Timer(Duration(minutes: 1), () => add(RotateSubscriptions()));
  }

  Future<void> _onSubscribeToRealTimeUpdates(
      SubscribeToRealTimeUpdates event, Emitter<ForexState> emit) async {
    await _priceSubscription?.cancel();
    try {
      final stream = getRealTimePrice(event.symbols);
      await emit.forEach<PriceUpdate>(
        stream,
        onData: (priceUpdate) {
          if (state is ForexLoaded) {
            final currentState = state as ForexLoaded;
            final updatedInstruments = currentState.instruments
                .map((instrument) => instrument.symbol == priceUpdate.symbol
                    ? instrument.copyWith(price: priceUpdate.price)
                    : instrument)
                .toList();
            return ForexLoaded(instruments: updatedInstruments);
          }
          return state;
        },
        onError: (error, stackTrace) {
          return ForexError(message: error.toString());
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(ForexError(message: 'Failed to subscribe: ${e.toString()}'));
      }
      _subscribeToNextBatch();
    }
  }

  Future<void> _onUnsubscribeFromRealTimeUpdates(
      UnsubscribeFromRealTimeUpdates event, Emitter<ForexState> emit) async {
    await _priceSubscription?.cancel();
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
      // Update subscriptions based on search results
      _allSymbols = searchResults.map((i) => i.symbol).toList();
      _currentSymbolIndex = 0;
      _subscribeToNextBatch();
    }
  }

  void _onRotateSubscriptions(
      RotateSubscriptions event, Emitter<ForexState> emit) {
    _subscribeToNextBatch();
  }

  void _onSortForexInstruments(
      SortForexInstruments event, Emitter<ForexState> emit) {
    if (state is ForexLoaded) {
      final currentState = state as ForexLoaded;
      final sortedInstruments =
          List<ForexInstrument>.from(currentState.instruments)
            ..sort((a, b) => event.ascending
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price));
      emit(ForexLoaded(instruments: sortedInstruments));
    }
  }

  @override
  Future<void> close() async {
    await _priceSubscription?.cancel();
    _rotationTimer?.cancel();
    return super.close();
  }
}
