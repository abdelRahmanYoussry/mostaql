import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../pages/settings/cubit/maarfy_settings_cubit/maarfy_settings_cubit.dart';
import '../theme/colors.dart';
import 'elevated_button.dart';

class ShareMyContactsWidget extends StatelessWidget {
  const ShareMyContactsWidget({super.key, required this.cubit, required this.phoneNumber});

  final MaarfySettingsCubit cubit;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 30.h, bottom: 15.h),
      contentPadding: EdgeInsets.only(bottom: 35.h, right: 25.w, left: 25.w),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      title: Picture(
        getAssetIcon('correct_icon.svg'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Loc.areYouSureToShareYourContacts(),
            style: getBoldBlack18Style(),
          ),
          Gap(20.h),
          Text(
            Loc.shareContactsDialogSubtitle(),
            style: getRegularGray16Style(),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomElevatedButton(
                onTap: () {
                  Navigator.pop(context);
                  cubit.shareConnection(phoneNumber);
                },
                buttonName: Loc.yesShare(),
                buttonColor: primary,
                context: context,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: CustomElevatedButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonName: Loc.noCancel(),
                  buttonTextStyle: getBoldBlue16Style(),
                  buttonColor: cancelColor,
                  context: context),
            ),
          ],
        ),
      ],
    );
  }
}
