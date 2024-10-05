import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_bloc.dart';
import 'package:flutter_trading_app/features/forex/presentation/bloc/forex_event.dart';
import 'package:flutter_trading_app/features/forex/presentation/pages/forex_list_page.dart';
import 'package:flutter_trading_app/features/home/presentation/home_page.dart';
import 'package:flutter_trading_app/features/splash/presentation/splash_page.dart';
import 'package:flutter_trading_app/injection_container.dart';

import 'irouter_provider.dart';

class AppRouter extends IRouterProvider {
  static const splash = "/";
  static const home = "/home";
  static const forex = "/forex";

  @override
  void initRouter(FluroRouter router) {
    router.define(splash, handler: Handler(handlerFunc: (context, params) {
      return const SplashPage();
    }));

    router.define(home, handler: Handler(handlerFunc: (context, params) {
      return const HomePage();
    }), transitionType: TransitionType.none);

    router.define(forex, handler: Handler(handlerFunc: (context, params) {
      return BlocProvider(
        create: (context) => sl<ForexBloc>()..add(LoadForexInstruments()),
        child: const ForexListPage(),
      );
    }));
  }
}
