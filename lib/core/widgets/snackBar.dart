import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mostaql/core/theme/styles_manager.dart';
import 'package:mostaql/core/widgets/picture.dart';
import 'package:size_config/size_config.dart';

import '../utils/get_asset_path.dart';

class SnackBarBuilder {
  static showFeedBackMessage(BuildContext context, String message, {bool addBehaviour = true, bool isSuccess = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Picture(
              getAssetIcon(isSuccess ? 'correct.svg' : 'wrong.svg'),
            ),
            Gap(
              15.w,
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.start,
                message,
                style: getRegularWhite14Style(),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        dismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 1),
        behavior: addBehaviour ? SnackBarBehavior.floating : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
