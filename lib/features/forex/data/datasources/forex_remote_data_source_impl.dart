import 'package:flutter_trading_app/core/constants/app_urls.dart';
import 'package:flutter_trading_app/core/error/exceptions.dart';
import 'package:flutter_trading_app/core/network/http_service/http_util.dart';
import 'package:flutter_trading_app/features/forex/data/models/forex_instrument_model.dart';
import 'forex_remote_data_source.dart';

class ForexRemoteDataSourceImpl implements ForexRemoteDataSource {
  final HttpUtil httpUtil;

  ForexRemoteDataSourceImpl({required this.httpUtil});

  @override
  Future<List<ForexInstrumentModel>> getForexInstruments() async {
    try {
      return await httpUtil.get<ForexInstrumentModel>(
        path: ApiConstants.forexSymbols,
        fromJson: ForexInstrumentModel.fromJsonFactory,
      );
    } on ServerException {
      throw ServerException();
    } on NetworkException {
      throw NetworkException();
    } on BadRequestException {
      throw BadRequestException();
    } on UnauthorizedException {
      throw UnauthorizedException();
    } on NotFoundException {
      throw NotFoundException();
    } on TimeoutException {
      throw TimeoutException();
    } on RequestCancelledException {
      throw RequestCancelledException();
    }
  }
}
