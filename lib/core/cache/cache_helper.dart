import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

///  definition:     this class is to use [SharedPreference] by calling some methods

class CacheHelper {
  final SharedPreferences _sharedPreferences;

  CacheHelper(this._sharedPreferences);

  ///  usage:   this method to check if the value is exists in [SharedPreferences]:
  ///  you need to pass String [key]
  ///  result: it will return if key is exists or not
  Future<bool> has(String key) async {
    final bool f = await _basicErrorHandling(() async {
      return _sharedPreferences.containsKey(key) &&
          _sharedPreferences.getString(key)!.isNotEmpty;
    });
    return f;
  }

  ///  usage:   this method to clear value  of the [key] in [SharedPreferences]:
  ///  you need to pass String [key]
  ///  result: it will return if [value] is cleared or not
  Future<bool> clear(String key) async {
    final bool f = await _basicErrorHandling(() async {
      return await _sharedPreferences.remove(key);
    });
    return f;
  }

  ///  usage:   this method to get value of the [key] in [SharedPreferences]:
  ///  you need to pass String [key]
  ///  result: it will return value of the [key] or [null] that the value isn't exists
  Future get(String key) async {
    final f = await _basicErrorHandling(() async {
      if (await has(key)) {
        return await jsonDecode(_sharedPreferences.getString(key)!);
      }
      return null;
    });
    return f;
  }

  ///  usage:   this method to put value of the [key] in [SharedPreferences]:
  ///  you need to pass String[key] and  dynamic[value]
  ///  result: it will return value of the [key] or [null] that the value isn't exists
  Future<bool> put(String key, dynamic value) async {
    final bool f = await _basicErrorHandling(() async {
      return await _sharedPreferences.setString(key, jsonEncode(value));
    });
    return f;
  }
}

extension on CacheHelper {
  Future<T> _basicErrorHandling<T>(Future<T> Function() onSuccess) async {
    try {
      final f = await onSuccess();
      return f;
    } catch (e) {
      rethrow;
    }
  }
}
