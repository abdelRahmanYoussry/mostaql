import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/widgets/elevated_button.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/utils/get_asset_path.dart';
import '../theme/colors.dart';

class DeleteBottomSheet extends StatelessWidget {
  const DeleteBottomSheet({super.key, required this.onYesClicked});
  final VoidCallback onYesClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 50.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Picture(
              getAssetIcon('delete.svg'),
            ),
            Gap(20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                textAlign: TextAlign.center,
                Loc.areYouSureAboutDeleting(),
                style: getMediumBlack23Style(),
              ),
            ),
            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    removeShadow: true,
                    onTap: () {
                      onYesClicked.call();
                      Navigator.pop(context);
                    },
                    context: context,
                    buttonName: Loc.yes(),
                  ),
                ),
                Gap(15.w),
                Expanded(
                  child: CustomElevatedButton(
                    context: context,
                    removeShadow: true,
                    buttonName: Loc.no(),
                    buttonTextStyle: const TextStyle(color: Colors.blue),
                    buttonColor: lightBlueColor,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
