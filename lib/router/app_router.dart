import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_bloc.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_event.dart';
import 'package:flutter_trading_app/features/forex/presentation/pages/forex_list_page.dart';
import 'package:flutter_trading_app/injection_container.dart';

import 'irouter_provider.dart';

class AppRouter extends IRouterProvider {
  static const home = "/";
  static const instrumentDetail = "/instrument/detail";

  @override
  void initRouter(FluroRouter router) {
    // Home page (Forex List Page)
    router.define(home, handler: Handler(handlerFunc: (context, params) {
      return BlocProvider(
        create: (context) => sl<ForexBloc>()..add(LoadForexInstruments()),
        child: const ForexListPage(),
      );
    }));

    // Instrument detail page
    // Commented out for now, as it's not implemented yet
    // router.define(instrumentDetail, handler: Handler(handlerFunc: (context, params) {
    //   final instrument = context!.settings!.arguments as ForexInstrument;
    //   return BlocProvider(
    //     create: (context) => sl<ForexBloc>(),
    //     child: InstrumentDetailPage(instrument: instrument),
    //   );
    // }));

    // Add more routes as needed
  }
}
