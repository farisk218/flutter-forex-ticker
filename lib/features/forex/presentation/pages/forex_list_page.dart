import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_bloc.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_event.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_state.dart';
import 'package:flutter_trading_app/features/forex/presentation/widgets/forex_list_item.dart';
import '../widgets/forex_search_bar.dart';

class ForexListPage extends StatefulWidget {
  const ForexListPage({Key? key}) : super(key: key);

  @override
  _ForexListPageState createState() => _ForexListPageState();
}

class _ForexListPageState extends State<ForexListPage> {
  final _searchController = TextEditingController();
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  bool _sortAscending = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<ForexBloc>().add(LoadForexInstruments());
    _itemPositionsListener.itemPositions.addListener(_onVisibleItemsChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    context.read<ForexBloc>().add(UnsubscribeFromRealTimeUpdates());
    super.dispose();
  }

  void _onVisibleItemsChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final visibleSymbols = _getVisibleSymbols();
      log('${visibleSymbols.length}');
      context.read<ForexBloc>().add(UpdateVisibleSymbols(visibleSymbols));
    });
  }

  List<String> _getVisibleSymbols() {
    final positions = _itemPositionsListener.itemPositions.value;
    final state = context.read<ForexBloc>().state;

    if (positions.isEmpty) return [];

    final firstIndex = positions.first.index;
    final lastIndex = positions.last.index;

    if (state is ForexLoaded) {
      return state.instruments
          .sublist(firstIndex.clamp(0, state.instruments.length - 1),
              lastIndex.clamp(0, state.instruments.length))
          .map((i) => i.symbol)
          .toList();
    } else if (state is ForexSearchResult) {
      return state.searchResults
          .sublist(firstIndex.clamp(0, state.searchResults.length - 1),
              lastIndex.clamp(0, state.searchResults.length))
          .map((i) => i.symbol)
          .toList();
    }
    return [];
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ForexBloc>().add(SearchForexInstruments(''));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.show_chart),
            SizedBox(
              width: 10,
            ),
            const Text('Forex'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_sortAscending ? Icons.sort_outlined : Icons.sort),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
              context
                  .read<ForexBloc>()
                  .add(SortForexInstruments(ascending: _sortAscending));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Feature in development'),
                  duration: Duration(milliseconds: 200),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FSearchBar(
            controller: _searchController,
            onChanged: (query) {
              context.read<ForexBloc>().add(SearchForexInstruments(query));
            },
            onClear: _clearSearch,
          ),
          Expanded(
            child: BlocConsumer<ForexBloc, ForexState>(
              listener: (context, state) {
                if (state is ForexLoaded || state is ForexSearchResult) {
                  // _sortAscending = (state as dynamic).instruments.first.price <=
                  //     (state as dynamic).instruments.last.price;
                }
              },
              builder: (context, state) {
                if (state is ForexLoading) {
                  return Center(
                    child: SpinKitFoldingCube(
                      color: Colors.white38,
                      size: 30.0,
                    ),
                  );
                } else if (state is ForexLoaded) {
                  return _buildForexList(state.instruments);
                } else if (state is ForexSearchResult) {
                  return _buildForexList(state.searchResults);
                } else if (state is ForexError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ForexBloc>()
                                .add(LoadForexInstruments());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForexList(List<ForexInstrument> instruments) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ForexBloc>().add(LoadForexInstruments());
      },
      child: ScrollablePositionedList.builder(
        itemCount: instruments.length,
        itemBuilder: (context, index) {
          final instrument = instruments[index];
          return ForexListItem(
            instrument: instrument,
          );
        },
        itemScrollController: _scrollController,
        itemPositionsListener: _itemPositionsListener,
      ),
    );
  }
}
