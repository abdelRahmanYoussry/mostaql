import 'package:flutter/material.dart';

import '../../../core/localization/loc_keys.dart';

class RateAppUnAvailable extends StatelessWidget {
  const RateAppUnAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        Loc.noReviews(),
      ),
      content: Text(
        Loc.noReviewMassage(),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            Loc.ok(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
