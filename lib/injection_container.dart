import 'package:dio/dio.dart';
import 'package:flutter_trading_app/core/network/http_service/http_util.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/network/socket_service/websocket_service.dart';
import 'features/forex/data/datasources/forex_local_data_source.dart';
import 'features/forex/data/datasources/forex_remote_data_source.dart';
import 'features/forex/data/datasources/forex_remote_data_source_impl.dart';
import 'features/forex/data/repositories/forex_repository_impl.dart';
import 'features/forex/domain/repositories/forex_repository.dart';
import 'features/forex/domain/usecases/get_forex_instruments.dart';
import 'features/forex/domain/usecases/get_real_time_price.dart';
import 'features/forex/presentation/bloc/forex_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => ForexBloc(
      getForexInstruments: sl(),
      getRealTimePrice: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetForexInstruments(sl()));
  sl.registerLazySingleton(() => GetRealTimePrice(sl()));

  // Repository
  sl.registerLazySingleton<ForexRepository>(
    () => ForexRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ForexRemoteDataSource>(
    () => ForexRemoteDataSourceImpl(httpUtil: sl()),
  );

  sl.registerLazySingleton<ForexLocalDataSource>(
    () => ForexLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<WebSocketService>(() => ForexWebSocketService());
  sl.registerLazySingleton(() => HttpUtil());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
