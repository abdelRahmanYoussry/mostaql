import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomDividerWidget extends StatelessWidget {
  const CustomDividerWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: greyMedium,
      thickness: 0.1,
    );
  }
}
