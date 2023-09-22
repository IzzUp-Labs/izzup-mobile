import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Models/globals.dart';
import '../../Models/job_offer_requests.dart';
import '../../Models/user.dart';
import '../modals.dart';
import '../navigation.dart';

class JobRequestNotificationHandler {
  static onJobRequestAccepted(JobOfferRequest jobOfferRequest) {
    if (kDebugMode) print('Job request accepted');
    Modals.showJobRequestSuccessModal(jobOfferRequest);
  }

  static onJobRequestConfirmed(String verificationCode, String requestId) {
    if (kDebugMode) print('Job request confirmed');
    if (Globals.profile?.role == UserRole.extra) {
      Modals.showJobEndModalExtra(verificationCode, requestId);
    } else {
      Modals.showJobEndModalEmployer(requestId);
    }
  }

  static onJobRequestFinished() {
    if (kDebugMode) print('Job request finished');
    final BuildContext? context = Navigation.navigatorKey.currentContext;
    if (context == null) return;

    if (Globals.profile?.role == UserRole.extra) {
      Navigator.of(context).pop();
    }
  }
}
