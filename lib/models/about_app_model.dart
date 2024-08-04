import 'package:equatable/equatable.dart';
import 'package:mostaql/models/global_response_model.dart';

import '../core/utils/vaildData/valid_data.dart';

class AboutAppModel extends GlobalResponseModel with EquatableMixin {
  final AboutAppData aboutAppData;

  AboutAppModel({
    required super.message,
    required super.error,
    required this.aboutAppData,
  });

  factory AboutAppModel.fromJson(Map<String, dynamic> json) {
    return AboutAppModel(
      aboutAppData: json['data'],
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        aboutAppData,
      ];
}

class AboutAppData {
  final String appVersion;
  final String appEmail;
  final String appPhone;

  AboutAppData({
    required this.appVersion,
    required this.appEmail,
    required this.appPhone,
  });

  factory AboutAppData.fromJson(Map<String, dynamic> json) {
    return AboutAppData(
      appVersion: json['app_version']!.toString(),
      appEmail: validateString(json['app_email']?.toString()),
      appPhone: validateString(json['app_phone']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(appVersion)) 'app_version': appVersion,
        if (validString(appEmail)) 'app_email': appEmail,
        if (validString(appPhone)) 'app_phone': appPhone,
      };
}
