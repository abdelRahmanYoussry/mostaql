import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class UserModel extends GlobalResponseModel with EquatableMixin {
  final UserData userData;

  UserModel({
    required super.message,
    required super.error,
    required this.userData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userData: UserData.fromJson(json['data']),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        userData,
      ];
}

class UserData {
  final String id;
  final String name;
  final String phone;
  final String token;
  final String avatar_url;

  UserData({
    required this.id,
    required this.name,
    required this.phone,
    required this.token,
    required this.avatar_url,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: validateString(json['id']?.toString()),
      name: validateString(json['name']?.toString()),
      phone: validateString(json['phone']?.toString()),
      token: validateString(json['token']?.toString()),
      avatar_url: validateString(json['avatar_url']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(name)) 'name': name,
        if (validString(phone)) 'phone': phone,
        if (validString(token)) 'token': token,
        if (validString(token)) 'avatar_url': avatar_url,
      };
}
