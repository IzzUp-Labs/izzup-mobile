import 'package:flutter/cupertino.dart';

import '../job_offer_requests.dart';

class JobOffersNotifier extends ChangeNotifier {
  List<JobOfferRequest> jobOffers = [];

  void addJobOfferList(List<JobOfferRequest> newJobOffers) {
    newJobOffers.sort((a, b) => a.startingDate.compareTo(b.startingDate));
    jobOffers = newJobOffers;
    notifyListeners();
  }
}