import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/app_config.dart';
import 'package:mostaql/core/navigation/nav.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/widgets/elevated_button.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../../core/di/di.dart';
import '../../../core/localization/loc_keys.dart';
import '../../../core/utils/get_asset_path.dart';
import '../../../core/utils/notifications/setup_local_notification.dart';

class UpdateContactsSheet extends StatelessWidget {
  const UpdateContactsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25.h,
        vertical: 50.h,
      ),
      // height: 500.h,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Picture(
              getAssetIcon('update.svg'),
            ),
            Gap(
              20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25.w,
              ),
              child: Text(
                textAlign: TextAlign.center,
                Loc.update_contacts_message(),
                style: getMediumBlack23Style(),
              ),
            ),
            Gap(
              30.h,
            ),
            CustomElevatedButton(
              context: context,
              removeShadow: true,
              onTap: () {
                Nav.updateUnCompleteContactScreen(
                  context,
                );
                kUpdateContactsMaybeLater = true;
              },
              buttonName: Loc.update(),
            ),
            Gap(
              20.h,
            ),
            CustomElevatedButton(
              context: context,
              removeShadow: true,
              buttonColor: Colors.grey.shade200,
              buttonTextStyle: getMediumBlack18Style(),
              onTap: () {
                kUpdateContactsMaybeLater = true;
                Navigator.pop(context);
                di<LocalNotificationService>().scheduleDailyNotification();
              },
              buttonName: Loc.another_time(),
            ),
          ],
        ),
      ),
    );
  }
}
