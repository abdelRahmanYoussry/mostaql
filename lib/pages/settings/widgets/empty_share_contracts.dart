import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/loc_keys.dart';
import '../../../core/theme/styles_manager.dart';

class EmptyShareContracts extends StatelessWidget {
  const EmptyShareContracts({super.key, required this.showNavToAdd});

  final bool showNavToAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        text: TextSpan(
          text: Loc.emptyShareContracts(),
          style: showNavToAdd ? getLightBlack16Style() : getMediumBlack16Style(),
          children: <TextSpan>[
            if (showNavToAdd)
              TextSpan(
                text: Loc.toShareClickHere(),
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              )
            // : TextSpan(
            //     text: Loc.pleaseShareContracts(),
            //     style: getMediumBlack16Style(),
            //   ),
          ],
        ),
      ),
    );
  }
}
