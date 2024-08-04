import 'package:flutter/material.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';

class AboutPrivacyWidget extends StatelessWidget {
  const AboutPrivacyWidget({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        width: 180.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            Loc.aboutPrivacy(),
            style: const TextStyle(color: primary),
          ),
        ),
      ),
    );
  }
}
