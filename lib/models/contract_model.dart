import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class ContactModel extends GlobalResponseModel with EquatableMixin {
  final List<ContactData> contractData;
  final Meta meta;

  ContactModel({required super.message, required super.error, required this.contractData, required this.meta});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contractData: (json['data'] as List).map((e) => ContactData.fromJson(e)).toList(),
      meta: Meta.fromJson(json['meta']),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        contractData,
      ];
}

class ContactData {
  final int id;
  final String name;
  final String phone;
  String? email;
  String? job;
  String? tags;
  String? address;
  String? notes;
  String? gender;
  PlaceOfBirth? placeOfBirth;
  PlaceOfWork? placeOfWork;
  User? user;

  ContactData({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.job,
    this.tags,
    this.address,
    this.notes,
    this.gender,
    this.placeOfBirth,
    this.placeOfWork,
    this.user,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json['id'],
      placeOfBirth: json['place_of_birth'] != null ? PlaceOfBirth.fromJson(json['place_of_birth']) : null,
      placeOfWork: json['place_of_work'] != null ? PlaceOfWork.fromJson(json['place_of_work']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      name: validateString(json['name']?.toString()),
      phone: validateString(json['phone']?.toString()),
      tags: validateString(json['tags']?.toString()),
      address: validateString(json['address']?.toString()),
      email: validateString(json['email']?.toString()),
      job: validateString(json['job']?.toString()),
      gender: validateString(json['gender']?.toString()),
      notes: validateString(json['notes']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(name)) 'name': name,
        if (validString(phone)) 'phone': phone,
        if (validString(tags)) 'tags': tags,
        if (validString(address)) 'address': address,
        if (validString(email)) 'email': email,
        if (validString(placeOfBirth)) 'place_of_birth': placeOfBirth,
        if (validString(placeOfWork)) 'place_of_work': placeOfWork,
        if (validString(tags)) 'tags': tags,
        if (validString(job)) 'job': job,
        if (validString(gender)) 'gender': gender,
      };
}

class PlaceOfBirth {
  int? id;
  String? name;

  PlaceOfBirth({this.id, this.name});

  PlaceOfBirth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class PlaceOfWork {
  int? id;
  String? title;

  PlaceOfWork({this.id, this.title});

  PlaceOfWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? avatar;
  String? dob;
  String? gender;
  String? description;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.avatar,
      this.dob,
      this.gender,
      this.description});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    dob = json['dob'];
    gender = json['gender'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['dob'] = dob;
    data['gender'] = gender;
    data['description'] = description;
    return data;
  }
}

class Meta {
  int? total;

  Meta({required this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }
//
}
