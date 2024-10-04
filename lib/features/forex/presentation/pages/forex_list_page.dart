import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    context.read<ForexBloc>().add(LoadForexInstruments());
  }

  @override
  void dispose() {
    _searchController.dispose();
    context.read<ForexBloc>().add(UnsubscribeFromRealTimeUpdates());
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ForexBloc>().add(LoadForexInstruments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Instruments'),
        actions: [
          IconButton(
            icon: Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
              context
                  .read<ForexBloc>()
                  .add(SortForexInstruments(ascending: _sortAscending));
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
            child: BlocBuilder<ForexBloc, ForexState>(
              builder: (context, state) {
                if (state is ForexLoading) {
                  return const Center(child: CircularProgressIndicator());
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
      child: ListView.builder(
        itemCount: instruments.length,
        itemBuilder: (context, index) {
          final instrument = instruments[index];
          final previousInstrument = index > 0 ? instruments[index - 1] : null;
          return ForexListItem(
            instrument: instrument,
            previousInstrument: previousInstrument,
          );
        },
      ),
    );
  }
}
