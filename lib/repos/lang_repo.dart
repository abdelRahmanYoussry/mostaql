import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:mostaql/app_config.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/core/utils/translation_helper.dart';

class LangRepo {
  final ApiHelper apiHelper;
  final CacheHelper cacheHelper;

  String? lang;

  LangRepo({
    required this.apiHelper,
    required this.cacheHelper,
  });

  Future<Either<String, void>> setLang(String lang, BuildContext context) async {
    try {
      this.lang = lang;
      cacheHelper.put(kUserLangKey, lang);
      context.setLocale(
        Locale(
          lang,
        ),
      );
      return const Right(null);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<Either<String, String>> getLang() async {
    try {
      final kLang = await cacheHelper.get(kUserLangKey);
      lang = kLang ?? kDefaultLanguage;
      return Right(lang!);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }
}
