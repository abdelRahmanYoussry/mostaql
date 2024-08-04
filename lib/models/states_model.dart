import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class StatesModel extends GlobalResponseModel with EquatableMixin {
  final List<StatesData> statesData;

  StatesModel({
    required super.message,
    required super.error,
    required this.statesData,
  });

  factory StatesModel.fromJson(Map<String, dynamic> json) {
    return StatesModel(
      statesData: (json['data'] as List).map((e) => StatesData.fromJson(e)).toList(),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        statesData,
      ];
}

class StatesData {
  late final int id;
  final String name;

  StatesData({
    required this.id,
    required this.name,
  });

  factory StatesData.fromJson(Map<String, dynamic> json) {
    return StatesData(
      id: json['id'],
      name: validateString(json['name']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(name)) 'name': name,
      };
}
