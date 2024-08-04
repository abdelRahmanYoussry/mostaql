import 'package:flutter/material.dart';
import 'package:mostaql/core/theme/colors.dart';

import '../theme/styles_manager.dart';

class GenderWidget extends StatelessWidget {
  const GenderWidget({super.key, required this.genderName, required this.isSelected});
  final String genderName;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration:
          BoxDecoration(color: isSelected ? selectedColor : Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Text(
        genderName,
        style: getRegularBlack14Style(),
      )),
    );
  }
}
