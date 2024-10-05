import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      onGenerateRoute: router.generator,
    );
  }
}
