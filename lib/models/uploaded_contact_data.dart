import '../core/utils/vaildData/valid_data.dart';

class UploadedContractData {
  final String name;
  final String phone;
  String? job;
  String? tags;
  String? gender;
  int? placeOfBirth;
  int? placeOfWork;

  UploadedContractData({
    required this.name,
    required this.phone,
    this.job,
    this.tags,
    this.gender,
    this.placeOfBirth,
    this.placeOfWork,
  });

  factory UploadedContractData.fromJson(Map<String, dynamic> json) {
    return UploadedContractData(
      placeOfBirth: json['place_of_birth'],
      placeOfWork: json['place_of_work'],
      name: validateString(json['name']?.toString()),
      phone: validateString(json['phone']?.toString()),
      tags: validateString(json['tags']?.toString()),
      job: validateString(json['job']?.toString()),
      gender: validateString(json['gender']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(name)) 'name': name,
        if (validString(phone)) 'phone': phone,
        if (validString(tags)) 'tags': tags,
        if (validString(placeOfBirth)) 'place_of_birth': placeOfBirth,
        if (validString(placeOfWork)) 'place_of_work': placeOfWork,
        if (validString(tags)) 'tags': tags,
        if (validString(job)) 'job': job,
        if (validString(gender)) 'gender': gender,
      };
}
