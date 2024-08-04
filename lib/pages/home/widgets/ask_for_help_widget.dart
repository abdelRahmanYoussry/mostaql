import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/utils/widget_utils.dart';

class AskForHelpWidget extends StatelessWidget {
  const AskForHelpWidget({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 35.w,
        vertical: 35.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(getCardRadius()),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(Loc.askForHelpMassage(), style: getRegularGrey18Style()),
            Gap(20.h),
            SizedBox(
              height: 50.h,
              child: ElevatedButton(
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(0),
                ),
                onPressed: () {
                  onTap.call();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Picture(getAssetIcon('chat_bubble_icon.svg')),
                    Gap(
                      10.w,
                    ),
                    Text(
                      Loc.askForHelpTitle(),
                      style: TextStyle(
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
