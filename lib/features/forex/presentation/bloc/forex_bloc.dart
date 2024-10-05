import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trading_app/core/usecase.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';
import 'package:flutter_trading_app/features/forex/domain/usecases/get_forex_instruments.dart';
import 'package:flutter_trading_app/features/forex/domain/usecases/get_last_prices.dart';
import 'package:flutter_trading_app/features/forex/domain/usecases/get_real_time_price.dart';
import 'forex_event.dart';
import 'forex_state.dart';

class ForexBloc extends Bloc<ForexEvent, ForexState> {
  final GetForexInstruments getForexInstruments;
  final GetRealTimePrice getRealTimePrice;
  final GetLastPrice getLastPrice;
  StreamSubscription? _priceSubscription;
  List<String> _visibleSymbols = [];
  List<String> _searchSymbols = [];
  List<ForexInstrument> _allInstruments = [];
  bool _sortAscending = true;

  ForexBloc({
    required this.getForexInstruments,
    required this.getRealTimePrice,
    required this.getLastPrice,
  }) : super(ForexInitial()) {
    on<LoadForexInstruments>(_onLoadForexInstruments);
    on<UpdateVisibleSymbols>(_onUpdateVisibleSymbols);
    on<UpdateForexPrice>(_onUpdateForexPrice);
    on<SearchForexInstruments>(_onSearchForexInstruments);
    on<SortForexInstruments>(_onSortForexInstruments);
  }

  Future<void> _onLoadForexInstruments(
      LoadForexInstruments event, Emitter<ForexState> emit) async {
    emit(ForexLoading());
    final result = await getForexInstruments(NoParams());
    result.fold(
      (failure) => emit(ForexError(message: failure.toString())),
      (instruments) {
        _allInstruments = instruments;
        emit(ForexLoaded(instruments: _sortInstruments(instruments)));
        _visibleSymbols = instruments
            .take(20)
            .map((instrument) => instrument.symbol)
            .toList();

        // TODO: To be implemented
        // for (var item in instruments.take(20).toList()) {
        //   _getLastPrice(item.displaySymbol);
        // }

        _updateSubscriptions();
      },
    );
  }

  void _onUpdateVisibleSymbols(
      UpdateVisibleSymbols event, Emitter<ForexState> emit) {
    _visibleSymbols = event.symbols;
    _updateSubscriptions();
  }

  void _onUpdateForexPrice(UpdateForexPrice event, Emitter<ForexState> emit) {
    final updatedInstruments = _allInstruments.map((instrument) {
      if (instrument.symbol == event.symbol) {
        return instrument.copyWith(price: event.price);
      }
      return instrument;
    }).toList();

    _allInstruments = updatedInstruments;

    if (state is ForexLoaded) {
      emit(ForexLoaded(instruments: _sortInstruments(updatedInstruments)));
    } else if (state is ForexSearchResult) {
      final currentState = state as ForexSearchResult;
      final updatedSearchResults = currentState.searchResults.map((instrument) {
        if (instrument.symbol == event.symbol) {
          return instrument.copyWith(price: event.price);
        }
        return instrument;
      }).toList();
      emit(ForexSearchResult(
          searchResults: _sortInstruments(updatedSearchResults)));
    }
  }

  void _onSearchForexInstruments(
      SearchForexInstruments event, Emitter<ForexState> emit) {
    final searchResults = _allInstruments
        .where((instrument) =>
            instrument.symbol.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    _searchSymbols = searchResults.map((i) => i.symbol).toList();
    emit(ForexSearchResult(searchResults: _sortInstruments(searchResults)));
    _updateSubscriptions();
  }

  void _onSortForexInstruments(
      SortForexInstruments event, Emitter<ForexState> emit) {
    _sortAscending = event.ascending;
    if (state is ForexLoaded) {
      final currentState = state as ForexLoaded;
      emit(
          ForexLoaded(instruments: _sortInstruments(currentState.instruments)));
    } else if (state is ForexSearchResult) {
      final currentState = state as ForexSearchResult;
      emit(ForexSearchResult(
          searchResults: _sortInstruments(currentState.searchResults)));
    }
  }

  List<ForexInstrument> _sortInstruments(List<ForexInstrument> instruments) {
    // TODO: Sort should be handled
    return instruments;
  }

  Future<void> _getLastPrice(symbol) async {
    await getLastPrice(symbol);
  }

  void _updateSubscriptions() {
    final prioritySymbols = {..._searchSymbols, ..._visibleSymbols}.toList();
    log("_updateSubscriptions $prioritySymbols");
    _priceSubscription?.cancel();
    _priceSubscription = getRealTimePrice(prioritySymbols).listen(
      (priceUpdate) {
        log("priceUpdate");
        add(UpdateForexPrice(
            symbol: priceUpdate.symbol, price: priceUpdate.price));
      },
      onError: (error) {
        emit(ForexError(message: error.toString()));
      },
    );
  }

  @override
  Future<void> close() async {
    await _priceSubscription?.cancel();
    return super.close();
  }
}
