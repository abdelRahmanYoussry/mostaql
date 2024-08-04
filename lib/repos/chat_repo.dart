import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/core/utils/notifications/setup_notifications.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/models/chat_ai_model.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:mostaql/repos/lang_repo.dart';

import '../app_config.dart';
import '../core/localization/loc_keys.dart';
import '../core/utils/translation_helper.dart';

class ChatAiRepo {
  final ApiHelper apiHelper;
  final LangRepo langRepo;
  final SetupFCM setupFCM;
  final CacheHelper cacheHelper;
  final AuthRepo authRepo;

  ChatAiRepo(
    this.apiHelper,
    this.langRepo,
    this.setupFCM,
    this.cacheHelper,
    this.authRepo,
  );

  Future<Either<String, ChatModel>> sendAiChatMassage({
    required String message,
  }) async {
    try {
      var response = await apiHelper.postData(
        EndPoints.chatWithAi,
        lang: langRepo.lang,
        token: authRepo.token,
        typeJSON: true,
        data: {
          "message": message,
        },
      );

      final data = jsonDecode(response);
      ChatModel chatModel = ChatModel.fromJson(data);
      if (chatModel.contacts.isEmpty) {
        return Left(
          Loc.noSearchResult(),
        );
      }
      return Right(chatModel);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }
}
