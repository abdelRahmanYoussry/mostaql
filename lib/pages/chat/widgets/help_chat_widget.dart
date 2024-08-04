import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/core/utils/media_query_values.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';

class HelpChatWidget extends StatelessWidget {
  const HelpChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(
          30.h,
        ),
        Picture(getAssetIcon('chatting_page_icon.svg')),
        Gap(
          35.h,
        ),
        SizedBox(
          width: context.width / 1.3,
          child: Column(
            children: [
              Text(
                Loc.aiTitle(),
                textAlign: TextAlign.justify,
                style: const TextStyle(color: greyMedium),
              ),
              Gap(5.h),
              Text(
                Loc.chatExample(),
                textAlign: TextAlign.justify,
                style: const TextStyle(color: greyMedium),
              ),
            ],
          ),
        ),
        Gap(65.h),
      ],
    );
  }
}
