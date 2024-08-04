import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mostaql/core/di/di.dart';
import 'package:mostaql/core/localization/loc_keys.dart';
import 'package:mostaql/core/navigation/nav.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/utils/get_asset_path.dart';
import 'package:mostaql/core/utils/widget_utils.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../../app_config.dart';
import '../../core/cache/cache_helper.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  static const int totalPages = 3;
  late final PageController pageController;
  late final ValueNotifier<int> index;

////// list of onBoard Images
  final List<String> images = [
    getAssetIcon('splash_3.svg'),
    getAssetIcon('splash_2.svg'),
    getAssetIcon('splash_1.svg'),
  ];

////// list of onBoard titles

  final List<String> titles = [
    Loc.splash_title_3(),
    Loc.splash_title_2(),
    Loc.splash_title_1(),
  ];

////// list of onBoard subTitles

  final List<String> subTitles = [
    Loc.splash_sub_title_3(),
    Loc.splash_sub_title_2(),
    Loc.splash_sub_title_1(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    index = ValueNotifier(0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: index,
              builder: (context, indexValue, child) {
                ///check if last index
                if (indexValue != totalPages - 1) {
                  return Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: InkWell(
                      onTap: () async {
                        di<CacheHelper>().put(kUserOnBoardIsSkipped, true);
                        Nav.mainLayoutScreens(context);
                      },
                      child: Container(
                        // height: 30.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 14.w,
                        ),
                        margin: EdgeInsetsDirectional.only(
                          top: 24.h,
                          end: 28.w,
                        ),
                        decoration: BoxDecoration(
                          color: greyF8,
                          borderRadius: BorderRadius.circular(getLowBorderRadius()),
                        ),
                        child: Text(
                          Loc.skip(),
                          style: TextStyle(
                            color: black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 55.h,
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  index.value = value;
                },
                children: [
                  for (int page = 0; page < totalPages; page++)
                    Column(
                      children: [
                        SizedBox(height: 50.h),
                        Container(
                          width: double.maxFinite,
                          alignment: AlignmentDirectional.center,
                          child: Picture(
                            images[page],
                            width: 330.w,
                            height: 272.h,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          titles[page],
                          style: getBoldBlack22Style(),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          subTitles[page],
                          textAlign: TextAlign.center,
                          style: getLightGray18Style(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 35.h),
            ValueListenableBuilder(
              valueListenable: index,
              builder: (context, indexValue, child) => Container(
                margin: EdgeInsets.symmetric(horizontal: 45.w),
                child: ElevatedButton(
                  onPressed: () {
                    if (indexValue == totalPages - 1) {
                      di<CacheHelper>().put(kUserOnBoardIsSkipped, true);

                      debugPrint('Go Login');
                      Nav.mainLayoutScreens(context);
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (_) => const LoginScreen()),
                      //       (route) => false,
                      // );
                      // final prefs = await SharedPreferences.getInstance();
                      // prefs.setBool('seen', true);
                    } else {
                      pageController.nextPage(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 20.h),
                    ),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: Text(
                    //check if last index go to login
                    indexValue == totalPages - 1 ? Loc.start_now() : Loc.next(),
                    textAlign: TextAlign.center,
                    style: getBoldWhite16Style(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            InkWell(
              onTap: () {
                Nav.mainLayoutScreens(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
                child: Text(
                  Loc.login(),
                  textAlign: TextAlign.center,
                  style: getBoldBlack16Style(),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            ValueListenableBuilder(
              valueListenable: index,
              builder: (context, indexValue, child) {
                return DotsIndicator(
                  dotsCount: totalPages,
                  // reversed: true,
                  position: indexValue,
                  decorator: DotsDecorator(
                    size: Size(10.h, 10.h),
                    spacing: EdgeInsets.only(left: 10.w, right: 10.w),
                    activeSize: Size(8.h, 8.h),
                    color: greyEB,
                    // Inactive color
                    activeColor: primary,
                  ),
                );
              },
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}
