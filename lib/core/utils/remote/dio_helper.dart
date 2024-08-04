import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mostaql/app_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class DioHelper {
  Future<dynamic> postMultiPart(String url, {dynamic data, required String token});
}

class DioImpl extends DioHelper {
  final Dio dioCode = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      receiveDataWhenStatusError: true,
    ),
  )..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));

  @override
  Future postMultiPart(String url, {dynamic data, required String token}) async {
    dioCode.options.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }
    return await _request(
      () async => await dioCode.post(url, data: data),
      url,
      data,
    );
  }
}

extension on DioHelper {
  Future _request(Future<Response> Function() request, String url, data) async {
    try {
      var r = await request.call();
      return r.data;
    } on DioError catch (e) {
      debugPrint('_request error $e');
      rethrow;
    } catch (e) {
      debugPrint('_request error $e');
      throw Exception();
    }
  }
}
