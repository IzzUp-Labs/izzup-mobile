import 'package:flutter/material.dart';

import '../../Models/job_offer_requests.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LastJobOfferListPage extends StatefulWidget {
  const LastJobOfferListPage({super.key});

  @override
  State<LastJobOfferListPage> createState() => _LastJobOfferListPageState();
}

class _LastJobOfferListPageState extends State<LastJobOfferListPage> {

  List<JobOfferRequest> jobOfferRequests = [];

  String authToken = "";

  _getMyJobOffers() async {
    jobOfferRequests = (await Api.getMyJobOffers())!;
    List<JobOfferRequest> filteredJobOfferRequests = [];
    for ( var jobOffer in jobOfferRequests) {
      if (jobOffer.isAvailable == false) {
        filteredJobOfferRequests.add(jobOffer);
      }
    }
    setState(() {
      jobOfferRequests = filteredJobOfferRequests;
    });
  }

  @override
  void initState() {
    _getMyJobOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _getMyJobOffers();
          },
          child: ListView.builder(
            itemCount: jobOfferRequests.length + 1 + (jobOfferRequests.isEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Text(
                      AppLocalizations.of(context)?.jobOffersList_jobOffers ?? "Job Offers",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
                  ),
                );
              } else {
                if (jobOfferRequests.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 3),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)?.jobOffersList_noJobsOffersYet ?? "No job offers yet 😢",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            AppColors.accent,
                            Color(0xFF008073),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jobOfferRequests[index - 1].jobTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  jobOfferRequests[index - 1].jobDescription,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      )
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}