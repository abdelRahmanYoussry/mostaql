import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../localization/loc_keys.dart';
import '../navigation/nav.dart';
import '../theme/consts.dart';
import '../theme/styles_manager.dart';
import '../utils/get_asset_path.dart';

class NoSearchResultWidget extends StatelessWidget {
  const NoSearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Picture(getAssetIcon('search_result_icon.svg')),
            Gap(20.h),
            Text(
              Loc.noSearchResult(),
              style: getBoldGray18Style(),
            ),
            Gap(5.h),
            Text(
              Loc.forBetterSearchResultMassage(),
              style: getRegularGrey14Style(),
            ),
            Gap(
              30.h,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0),
              ),
              onPressed: () {
                Nav.chatScreen(
                  context: context,
                  isTextFormFocused: true,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Picture(
                    getAssetIcon('chat_bubble_icon.svg'),
                  ),
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
          ],
        ),
      ),
    );
  }
}
