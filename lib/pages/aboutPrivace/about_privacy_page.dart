import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/theme/consts.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:size_config/size_config.dart';

class AboutPrivacyPage extends StatelessWidget {
  AboutPrivacyPage({super.key});

  final phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: lowAppBarHeight,
        title: Text(
          Loc.aboutPrivacy(),
          style: getHeavyBlack18Style(),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(35.h),
              Text(
                Loc.terms_and_condition_content(), // temp text
                style: getThinGrey16Style(),
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
