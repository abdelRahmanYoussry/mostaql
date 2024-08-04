import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:size_config/size_config.dart';

class PersonCardShimmerWidget extends StatelessWidget {
  const PersonCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
        color: Colors.white,
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              color: Colors.grey[300],
            ),
            Gap(
              10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20.h,
                    color: Colors.grey[300],
                  ),
                  Gap(
                    10.h,
                  ),
                  Container(
                    height: 14.h,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            Gap(
              5.w,
            ),
            Container(
              padding: EdgeInsets.all(
                10.h,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              width: 80.w,
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
