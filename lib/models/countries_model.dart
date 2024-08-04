import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class CountriesModel extends GlobalResponseModel with EquatableMixin {
  final List<CountriesData> countriesData;

  CountriesModel({
    required super.message,
    required super.error,
    required this.countriesData,
  });

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      countriesData: (json['data'] as List).map((e) => CountriesData.fromJson(e)).toList(),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        countriesData,
      ];
}

class CountriesData {
  final int id;
  final String name;

  CountriesData({
    required this.id,
    required this.name,
  });

  factory CountriesData.fromJson(Map<String, dynamic> json) {
    return CountriesData(
      id: json['id'],
      name: validateString(json['name']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(name)) 'name': name,
      };
}
