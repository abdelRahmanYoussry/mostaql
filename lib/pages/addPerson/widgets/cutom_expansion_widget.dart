import 'package:flutter/material.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:size_config/size_config.dart';

import '../../../core/theme/colors.dart';

class CustomExpansionWidget extends StatelessWidget {
  const CustomExpansionWidget({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    required this.controller,
    required this.onExpansionChanged,
  });

  final String title;
  final List<Widget> children;
  final ExpansionTileController controller;
  final Function(bool) onExpansionChanged;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: controller,
      onExpansionChanged: onExpansionChanged,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      initiallyExpanded: initiallyExpanded,
      tilePadding: EdgeInsets.only(left: 25.w, right: 25.w),
      iconColor: greyMedium,
      shape: InputBorder.none,
      title: Text(
        title,
        style: getBoldGray18Style(),
      ),
      children: children,
    );
  }
}
