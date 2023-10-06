import 'package:flutter/material.dart';

import '../job_offer_requests.dart';

class JobRequestWithVerificationCodeNotifier extends ChangeNotifier {
  List<JobRequestWithVerificationCode> requests = [];

  void addJobRequestList(List<JobRequestWithVerificationCode> newRequests) {
    newRequests.sort((a, b) =>
        a.jobOffer.startingDate.compareTo(b.jobOffer.startingDate));
    requests = newRequests;
    notifyListeners();
  }

}