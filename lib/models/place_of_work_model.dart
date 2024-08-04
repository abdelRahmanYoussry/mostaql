import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class PlaceOfWorkModel extends GlobalResponseModel with EquatableMixin {
  final List<PlaceOfWorkData> placeOfWorkDataList;

  PlaceOfWorkModel({
    required super.message,
    required super.error,
    required this.placeOfWorkDataList,
  });

  factory PlaceOfWorkModel.fromJson(Map<String, dynamic> json) {
    return PlaceOfWorkModel(
      placeOfWorkDataList: (json['data'] as List).map((e) => PlaceOfWorkData.fromJson(e)).toList(),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        placeOfWorkDataList,
      ];
}

class PlaceOfWorkData {
  late final int id;
  final String title;

  PlaceOfWorkData({
    required this.id,
    required this.title,
  });

  factory PlaceOfWorkData.fromJson(Map<String, dynamic> json) {
    return PlaceOfWorkData(
      id: json['id'],
      title: validateString(json['title']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(title)) 'title': title,
      };
}
