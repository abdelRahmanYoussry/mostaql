import 'package:mostaql/parameters/filter_paramaters.dart';

import 'core/localization/loc_keys.dart';

abstract class AppConfig {
  static String baseUrl = 'https://maarfi.spotlayer.com/api/$version';

  static String version = 'v1/';
}

const kUserLangKey = "lang";
const kDefaultLanguage = Loc.en;
const kUserKey = "user";
const kUserToken = "token";
const kUserOnBoardIsSkipped = "onBoardingSkipped";
bool kUpdateContactsMaybeLater = false;

///firebase
const firebaseApiKey = 'AIzaSyAiJDY15P4hRNQcZKn8fIekoA9COcUIeDU';
const firebaseAppId = '1:1051843546353:android:b820677e74be5beafc2d50';
const firebaseMessagingSenderId = '1051843546353';
const firebaseMessagingProjectId = 'maarfy-c8634';

abstract class EndPoints {
  // auth
  static String loginWithDataBase = 'login';
  static String updateUserWithDataBase = 'profile';
  static String addContracts = 'my-contacts';

  static String updateContracts({required int id}) => 'my-contacts/$id';

  static String searchContracts({FilterParameters? filterParameters, required int perPage, required int page}) {
    filterParameters?.categoryId ??= '';
    filterParameters?.term ??= '';
    filterParameters?.stateId ??= '';
    return 'my-contacts?per_page=$perPage&page=$page&term=${filterParameters?.term}&state=${filterParameters?.stateId}&category=${filterParameters?.categoryId}';
  }

  static String countries = 'location/countries';

  static String placeOfWOrk = 'work-categories';

  static String states({required countryId}) => 'location/states?country_id=$countryId';

  static String cities({required stateId}) => 'location/cities?state_id=$stateId';

  static String uploadContact = 'my-contacts/upload';

  static String unCompletedContact = 'my-contacts/uncompleted';

  static String getProfile = "profile";

  static String getRecentlyProfileImages = "profile-photo-history";

  static String aboutApp = "about-app";

  static String getFriendConnections = "connections";

  static String chatWithAi = "assistant";

  static String getUserContactsFromDataBase(
      {required int page, required int perPage, FilterParameters? filterParameters}) {
    final term = filterParameters?.term ?? '';
    final stateId = filterParameters?.stateId ?? '';
    final categoryId = filterParameters?.categoryId ?? '';

    return 'my-contacts/my-own/contacts?per_page=$perPage&page=$page&term=$term&state=$stateId&category=$categoryId';
  }

  static String deleteFriendConnections(int id) => "connections/$id";

  static String deleteManyContacts({required List<int> contactIds}) {
    return 'my-contacts/destroy/many?${Uri(
      queryParameters: {for (var i = 0; i < contactIds.length; i++) 'ids[$i]': contactIds[i].toString()},
    )}';
  }

  static String code = ''; // todo
  static String logout = ''; // todo
  static String updateDeviceToken = ''; // todo
}
