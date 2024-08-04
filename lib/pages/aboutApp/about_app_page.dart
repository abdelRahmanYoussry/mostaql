import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/utils/extensions/text_theme_extension.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:mostaql/pages/settings/cubit/settings_cubit.dart';
import 'package:mostaql/pages/settings/cubit/settings_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:size_config/size_config.dart';

import '../../core/di/di.dart';
import '../../core/localization/loc_keys.dart';
import '../../core/theme/consts.dart';
import '../../main.dart';
import '../settings/widgets/profile_shimmer.dart';
import 'app_review_service.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<SettingsPageCubit>()..getAboutAppInfo(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.s,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: lowAppBarHeight,
          title: Text(
            Loc.aboutApp(),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: BlocSelector<SettingsPageCubit, SettingsPageState, GetAboutAppData>(
            selector: (state) => state.getAboutAppData,
            builder: (context, state) {
              return state.loadingState.loading
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const ProfileShimmer(),
                    ) // temp
                  : Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300.h,
                              color: const Color(0xFFE7F0F6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Picture(
                                    getAssetIcon('logo.svg'),
                                    width: 90.w,
                                    height: 115.h,
                                  ),
                                  Gap(30.h),
                                  if (state.aboutAppData != null)
                                    Text(
                                      'V ${packageInfo?.version}',
                                      style: context.titleLarge?.copyWith(fontSize: 24.s),
                                    ),
                                  Gap(
                                    10.h,
                                  ),
                                  //todo handle this when data from api is not empty
                                  if (state.aboutAppData != null &&
                                      state.aboutAppData!.appVersion == packageInfo?.version)
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        Loc.lastUpdate(),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -120.h,
                              left: 27.w,
                              right: 27.w,
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: double.infinity,
                                height: 180.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Loc.aboutApp(),
                                      style: context.titleLarge,
                                    ),
                                    Gap(5.h),
                                    Text(
                                      Loc.aboutAppDescription(),
                                      style: context.boySmall?.copyWith(
                                        color: grey4A,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Gap(130.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPadding),
                          child: Column(
                            children: [
                              if (checkForEmptyValue(state))
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 30.h,
                                  ),
                                  width: double.infinity,
                                  // height: 160.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Loc.callUs(),
                                        style: context.titleLarge,
                                      ),
                                      Gap(10.h),
                                      Row(
                                        children: [
                                          Picture(
                                            getAssetIcon(
                                              'envlope.svg',
                                            ),
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                          Gap(
                                            10.w,
                                          ),
                                          //todo handle this when data from api is not empty
                                          state.aboutAppData != null
                                              ? Text(
                                                  'Email:   ${state.aboutAppData!.appEmail}',
                                                )
                                              : const Text(
                                                  'Email:  alogiriza@gmail.com',
                                                )
                                        ],
                                      ),
                                      Gap(
                                        10.h,
                                      ),
                                      Row(
                                        children: [
                                          Picture(
                                            getAssetIcon(
                                              'phone_small.svg',
                                            ),
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                          Gap(10.w),
                                          //todo handle this when data from api is not empty
                                          state.aboutAppData != null
                                              ? Text(
                                                  'Phone: ${state.aboutAppData!.appPhone}',
                                                )
                                              : const Text(
                                                  'Phone: 002132123213',
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              Gap(10.h),
                              GestureDetector(
                                onTap: () {
                                  //todo change static url to app link
                                  Share.share('https://play.google.com/store/apps/details?id=turbo.captain.com&pli=1');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  // width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      Expanded(
                                        child: Text(
                                          Loc.shareApp(),
                                          style: context.titleMedium?.copyWith(
                                            color: primary,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Icon(
                                          CupertinoIcons.arrow_turn_up_right,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Gap(
                                10.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Nav.rateAppDialog(context);
                                  di<AppReviewService>().requestReview(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      Expanded(
                                        child: Text(
                                          Loc.rate_app(),
                                          style: context.titleMedium?.copyWith(
                                            color: primary,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Icon(
                                          Icons.star_border_purple500_outlined,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  bool checkForEmptyValue(GetAboutAppData state) {
    if (state.aboutAppData == null) {
      return false;
    } else {
      return true;
    }
  }
}
