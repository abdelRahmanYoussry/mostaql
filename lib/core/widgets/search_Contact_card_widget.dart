import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/widgets/custom_divider.dart';
import 'package:mostaql/core/widgets/phone_number_contact_widget.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:size_config/size_config.dart';

import '../di/di.dart';
import '../theme/colors.dart';
import '../theme/styles_manager.dart';
import '../utils/get_asset_path.dart';

class SearchPersonCardWidget extends StatelessWidget {
  const SearchPersonCardWidget({
    super.key,
    required this.phoneNumber,
    required this.personName,
    this.placeOfBirth,
    this.placeOfWork,
    this.job,
    required this.user,
    required this.imageUrl,
    required this.onClicked,
    required this.onMarffyClick,
  });

  final String phoneNumber;
  final String personName;
  final String? job;
  final String? placeOfWork;
  final String? placeOfBirth;
  final String user;
  final String imageUrl;
  final VoidCallback onClicked;
  final VoidCallback onMarffyClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClicked.call();
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          top: 25.h,
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != di<AuthRepo>().user?.name)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: primary),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        child: Text(
                          'AppName',
                          style: getRegularWhite14Style(),
                        ),
                      ),
                      Gap(
                        10.w,
                      ),
                      Text(
                        user,
                        style: getMediumBlue14Style(),
                      ),
                      Gap(
                        10.w,
                      ),
                      Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              onMarffyClick.call();
                            },
                            child: const Icon(
                              Icons.call,
                              color: primary,
                              size: 20,
                            ),
                          ))
                    ],
                  ),
                  Gap(
                    10.h,
                  ),
                  const CustomDivider(),
                  Gap(
                    20.h,
                  ),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    personName,
                    style: getBoldBlack20Style(),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Gap(
                  7.w,
                ),
                PhoneNumberContactWidget(
                  phoneNumber: phoneNumber,
                )
              ],
            ),
            Gap(
              10.h,
            ),
            Visibility(
              visible: job!.length > 1 || placeOfWork != null,
              child: Row(
                children: [
                  Picture(
                    getAssetIcon(
                      'job.svg',
                    ),
                    width: 20.w,
                    height: 20.h,
                  ),
                  Gap(
                    10.w,
                  ),
                  Text(
                    '$job${placeOfWork != null ? '/$placeOfWork' : ''}',
                    style: getMediumGrey14Style(),
                  ),
                ],
              ),
            ),
            Gap(
              10.h,
            ),
            if (placeOfBirth != null)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Picture(
                      getAssetIcon(
                        'location.svg',
                      ),
                      width: 20.w,
                      height: 20.h,
                    ),
                    Gap(
                      10.w,
                    ),
                    Text(
                      placeOfBirth!,
                      style: getMediumGrey14Style(),
                    ),
                  ],
                ),
              ),
            if (user == di<AuthRepo>().user?.name)
              Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: Row(
                  children: [
                    Picture(
                      getAssetIcon(
                        'person.svg',
                      ),
                      width: 20.w,
                      height: 20.h,
                    ),
                    Gap(
                      10.w,
                    ),
                    Text(
                      user,
                      style: getMediumGrey14Style(),
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
