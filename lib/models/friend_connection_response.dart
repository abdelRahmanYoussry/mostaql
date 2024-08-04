import 'package:mostaql/models/global_response_model.dart';

import 'contract_model.dart';

class FriendConnectionResponse extends GlobalResponseModel {
  final List<FriendConnectionModel> friendConnections;

  FriendConnectionResponse({
    required this.friendConnections,
    required super.message,
    required super.error,
  });

  factory FriendConnectionResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<FriendConnectionModel> data = dataList.map((i) => FriendConnectionModel.fromJson(i)).toList();

    return FriendConnectionResponse(
      friendConnections: data,
      error: json['error'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((i) => i.toJson()).toList(),
      'error': error,
      'message': message,
    };
  }
}

class FriendConnectionModel {
  final int id;
  final String status;
  final User user;

  FriendConnectionModel({
    required this.id,
    required this.status,
    required this.user,
  });

  factory FriendConnectionModel.fromJson(Map<String, dynamic> json) {
    return FriendConnectionModel(
      id: json['id'],
      status: json['status'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'user': user.toJson(),
    };
  }
}

class FriendConnectionData {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String avatar;
  final String? dob;
  final String? gender;
  final String? description;

  FriendConnectionData({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    required this.avatar,
    this.dob,
    this.gender,
    this.description,
  });

  factory FriendConnectionData.fromJson(Map<String, dynamic> json) {
    return FriendConnectionData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      dob: json['dob'],
      gender: json['gender'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'dob': dob,
      'gender': gender,
      'description': description,
    };
  }
}
