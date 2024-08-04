import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';

class RecentlyProfilePhotosModel extends GlobalResponseModel with EquatableMixin {
  final List<RecentlyPhotoData> photosList;

  RecentlyProfilePhotosModel({
    required super.message,
    required super.error,
    required this.photosList,
  });

  factory RecentlyProfilePhotosModel.fromJson(Map<String, dynamic> json) {
    return RecentlyProfilePhotosModel(
      photosList: (json['data'] as List).map((e) => RecentlyPhotoData.fromJson(e)).toList(),
      message: json["message"],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [
        photosList,
      ];
}

class RecentlyPhotoData {
  final int id;
  final String avatarId;
  final String avatarUrl;

  RecentlyPhotoData({
    required this.id,
    required this.avatarId,
    required this.avatarUrl,
  });

  factory RecentlyPhotoData.fromJson(Map<String, dynamic> json) {
    return RecentlyPhotoData(
      id: json['id'],
      avatarId: validateString(json['avatar_id']?.toString()),
      avatarUrl: validateString(json['avatar_url']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (validString(id)) 'id': id,
        if (validString(avatarId)) 'avatar_id': avatarId,
        if (validString(avatarUrl)) 'avatar_url': avatarUrl,
      };
}
