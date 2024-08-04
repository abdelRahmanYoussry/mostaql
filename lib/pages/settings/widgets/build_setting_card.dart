import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:size_config/size_config.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/get_asset_path.dart';
import '../../../core/widgets/picture.dart';

class BuildSettingCard extends StatelessWidget {
  const BuildSettingCard({
    super.key,
    required this.title,
    required this.onClicked,
    required this.icn,
    this.isUpdateContacts = false,
    this.contactsLengthNum,
  });

  final VoidCallback onClicked;
  final String icn;
  final String title;
  final String? contactsLengthNum;
  final bool? isUpdateContacts;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClicked.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.white,
        height: 70.h,
        child: Row(
          children: [
            Picture(
              getAssetIcon(icn),
              width: 25.w,
              height: 20.h,
            ),
            Gap(
              10.w,
            ),
            Text(
              title,
              style: getMediumBlack16Style(),
            ),
            const Spacer(),
            if (isUpdateContacts! && contactsLengthNum != null)
              Container(
                width: 60.w,
                height: 35.h,
                margin: EdgeInsets.only(left: 10.w),
                decoration: const BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      16,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    contactsLengthNum!,
                    style: getMediumBlack16Style(),
                  ),
                ),
              ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.s,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
