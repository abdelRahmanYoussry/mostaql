import 'package:flutter/material.dart';
import 'package:mostaql/core/widgets/picture.dart';

import '../../../core/theme/consts.dart';
import '../../../models/recently_profile_photos_model.dart';

class ProfilePicsGrid extends StatelessWidget {
  const ProfilePicsGrid({super.key, required this.recentlyPhotoData, required this.onImageClicked});

  final List<RecentlyPhotoData> recentlyPhotoData;
  final ValueChanged<RecentlyPhotoData>? onImageClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(hPadding),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: recentlyPhotoData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () {
                onImageClicked!.call(recentlyPhotoData[index]);
              },
              child: Picture(
                recentlyPhotoData[index].avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
