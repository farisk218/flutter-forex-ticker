import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final router = FluroRouter();

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    appRouter.initRouter(router);

    return MaterialApp(
      title: 'Exinity Real-time Price Checker',
      theme: AppTheme.darkTheme,
      onGenerateRoute: router.generator,
    );
  }
}
