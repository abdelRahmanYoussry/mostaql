import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class CitiesModel extends GlobalResponseModel with EquatableMixin {
  final List<CitiesData> citiesData;

  CitiesModel({
    required super.message,
    required super.error,
    required this.citiesData,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) {
    return CitiesModel(
      citiesData: (json['data'] as List).map((e) => CitiesData.fromJson(e)).toList(),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        citiesData,
      ];
}

class CitiesData {
  final int id;
  final String name;

  CitiesData({
    required this.id,
    required this.name,
  });

  factory CitiesData.fromJson(Map<String, dynamic> json) {
    return CitiesData(
      id: json['id'],
      name: validateString(json['name']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(name)) 'name': name,
      };
}
