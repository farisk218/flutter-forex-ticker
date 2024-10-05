import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_trading_app/features/forex/domain/entities/forex_instrument.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_bloc.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_event.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_state.dart';
import 'package:flutter_trading_app/features/forex/presentation/widgets/forex_list_item.dart';
import '../widgets/forex_search_bar.dart';
import '../widgets/initial_loading_dialog.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) => InitialLoadDialog(),
      );
    });
}

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    context.read<ForexBloc>().add(UnsubscribeFromRealTimeUpdates());
    super.dispose();
  }

  void _onVisibleItemsChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final visibleSymbols = _getVisibleSymbols();
      log('Visible symbols: ${visibleSymbols.length}');
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
      return _getSymbolsFromList(state.instruments, firstIndex, lastIndex);
    } else if (state is ForexSearchResult) {
      return _getSymbolsFromList(state.searchResults, firstIndex, lastIndex);
    }
    return [];
  }

  List<String> _getSymbolsFromList(
      List<ForexInstrument> instruments, int firstIndex, int lastIndex) {
    return instruments
        .sublist(firstIndex.clamp(0, instruments.length - 1),
            lastIndex.clamp(0, instruments.length))
        .map((i) => i.symbol)
        .toList();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ForexBloc>().add(SearchForexInstruments(''));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          FSearchBar(
            controller: _searchController,
            onChanged: (query) =>
                context.read<ForexBloc>().add(SearchForexInstruments(query)),
            onClear: _clearSearch,
          ),
          Expanded(
            child: BlocBuilder<ForexBloc, ForexState>(
              builder: (context, state) {
                if (state is ForexLoading) {
                  return _buildLoadingIndicator();
                } else if (state is ForexLoaded) {
                  return _buildForexList(state.instruments);
                } else if (state is ForexSearchResult) {
                  return _buildForexList(state.searchResults);
                } else if (state is ForexError) {
                  return _buildErrorView(state.message);
                }
                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.show_chart, size: 24.sp),
          SizedBox(width: 10.w),
          Text('Forex', style: TextStyle(fontSize: 18.sp)),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(_sortAscending ? Icons.sort_outlined : Icons.sort,
              size: 24.sp),
          onPressed: _toggleSort,
        ),
      ],
    );
  }

  void _toggleSort() {
    setState(() => _sortAscending = !_sortAscending);
    context
        .read<ForexBloc>()
        .add(SortForexInstruments(ascending: _sortAscending));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feature in development'),
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitFoldingCube(
        color: Colors.white38,
        size: 30.0.sp,
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message', style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () =>
                context.read<ForexBloc>().add(LoadForexInstruments()),
            child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildForexList(List<ForexInstrument> instruments) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<ForexBloc>().add(LoadForexInstruments()),
      child: ScrollablePositionedList.builder(
        itemCount: instruments.length,
        itemBuilder: (context, index) =>
            ForexListItem(instrument: instruments[index]),
        itemScrollController: _scrollController,
        itemPositionsListener: _itemPositionsListener,
      ),
    );
  }
}
