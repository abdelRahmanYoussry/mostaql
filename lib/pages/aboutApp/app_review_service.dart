import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mostaql/core/navigation/nav.dart';

class AppReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> requestReview(BuildContext context) async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      Nav.rateUnavailableAppDialog(context);
    }
  }
}
