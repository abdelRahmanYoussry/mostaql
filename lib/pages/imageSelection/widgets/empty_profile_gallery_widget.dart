import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/theme/styles_manager.dart';
import '../../../core/utils/get_asset_path.dart';
import '../../../core/widgets/picture.dart';

class EmptyProfileGalleryWidget extends StatelessWidget {
  const EmptyProfileGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Gap(
            120.h,
          ),
          Picture(
            getAssetIcon('image-upload.svg'),
          ),
          Gap(30.h),
          Text(
            Loc.profileHasNoImags(),
            style: getRegularBlack20Style(),
          ),
        ],
      ),
    );
  }
}
