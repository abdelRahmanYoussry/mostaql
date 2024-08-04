import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:size_config/size_config.dart';

class LangCustomExpansionWidget extends StatelessWidget {
  const LangCustomExpansionWidget({
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
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      tilePadding: EdgeInsets.only(left: 20.w, right: 19.w),
      iconColor: Colors.black,
      // leading: const Icon(Icons.language),
      // trailing: Icon(
      //   Icons.arrow_forward_ios,
      //   size: 16.s,
      // ),
      shape: InputBorder.none,
      title: Row(
        children: [
          const Icon(Icons.language),
          Gap(3.w),
          Text(
            title,
            style: getMediumBlack16Style(),
          ),
        ],
      ),
      children: children,
    );
  }
}
