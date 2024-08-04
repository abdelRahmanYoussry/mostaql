import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:size_config/size_config.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/elevated_button.dart';

class RateAppWidget extends StatelessWidget {
  RateAppWidget({super.key});
  late double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 30.h, bottom: 15.h),
      contentPadding: EdgeInsets.only(bottom: 35.h, right: 25.w, left: 25.w),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      title: Center(
        child: Text(
          Loc.rate_app(),
          style: getMediumBlack18Style(),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(
            10.h,
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            glowColor: Colors.white,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, index) {
              return const Icon(
                Icons.star,
                color: Colors.amber,
              );
            },
            onRatingUpdate: (rating) {
              _rating = rating;
            },
          ),
          Gap(
            10.h,
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
                },
                buttonName: Loc.yes(),
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
