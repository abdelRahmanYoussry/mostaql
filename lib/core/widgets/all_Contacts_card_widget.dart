import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/widgets/custom_divider.dart';
import 'package:mostaql/core/widgets/phone_number_contact_widget.dart';
import 'package:size_config/size_config.dart';

import '../localization/loc_keys.dart';
import '../theme/colors.dart';
import '../theme/styles_manager.dart';

class AllContactCardWidget extends StatelessWidget {
  const AllContactCardWidget({
    super.key,
    required this.phoneNumber,
    required this.personName,
    required this.onClicked,
    required this.onDelete,
    required this.onEdit,
    required this.onRadioButtonChecked,
    required this.onChangeValue,
  });

  final String phoneNumber;
  final String personName;
  final VoidCallback onClicked;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool onRadioButtonChecked;
  final Function(bool) onChangeValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClicked.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 20.h,
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: onRadioButtonChecked,
                    activeColor: primary,
                    onChanged: (newValue) {
                      onChangeValue(newValue ?? false);
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return primary;
                        }
                        return Colors.white.withOpacity(0.5); // Unselected color
                      },
                    ),
                  ),
                ),
                Gap(
                  10.w,
                ),
                Expanded(
                  child: Text(
                    personName,
                    style: getBoldBlack16Style(),
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
              15.h,
            ),
            const CustomDivider(),
            Gap(
              15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    onDelete.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Gap(5.w),
                        Text(
                          Loc.delete(),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(
                  20.w,
                ),
                GestureDetector(
                  onTap: () {
                    onEdit.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Gap(5.w),
                        Text(
                          Loc.edit(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(5.h),
          ],
        ),
      ),
    );
  }
}
