import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/colors.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../localization/loc_keys.dart';
import '../theme/styles_manager.dart';
import '../utils/get_asset_path.dart';
import 'custom_divider.dart';

class FriendListItem extends StatelessWidget {
  const FriendListItem({
    super.key,
    required this.phoneNumber,
    required this.personName,
    required this.imgUrl,
    required this.countryCode,
    required this.onDelete,
    this.showDelete = true,
  });

  final String phoneNumber;
  final String countryCode;
  final String personName;
  final String imgUrl;
  final VoidCallback onDelete;
  final bool showDelete;
  final holderImageUrl = 'https://maarfi.spotlayer.com/vendor/core/core/base/images/placeholder.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              imgUrl != holderImageUrl
                  ? ClipOval(
                      child: Picture(
                        imgUrl.isNotEmpty
                            ? imgUrl
                            : getAssetIcon(
                                'person-tie.svg',
                              ),
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Picture(
                        getAssetImage(
                          'placeHolderNew.png',
                        ),
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    ),
              Gap(
                10.w,
              ),
              Expanded(
                child: Text(
                  personName.length > 5 ? personName : Loc.noName(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getBoldBlack20Style(),
                ),
              ),
              // const Spacer(),
              Gap(
                5.w,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 20.w,
                ),
                decoration: const BoxDecoration(
                  color: greyScaffold,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      20,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      phoneNumber,
                      style: getMediumBlack14Style(),
                    ),
                    Gap(
                      5.w,
                    ),
                    Picture(
                      getAssetIcon(
                        'phone.svg',
                      ),
                      width: 14.w,
                      height: 14.h,
                      color: Colors.green,
                    )
                  ],
                ),
              )
            ],
          ),
          if (showDelete)
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: CustomDivider(),
            ),
          if (showDelete)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: GestureDetector(
                onTap: () {
                  onDelete.call();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 20,
                      color: kDefaultIconDarkColor,
                    ),
                    Gap(
                      10.w,
                    ),
                    Text(
                      Loc.delete(),
                      style: getMediumGrey18Style(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
