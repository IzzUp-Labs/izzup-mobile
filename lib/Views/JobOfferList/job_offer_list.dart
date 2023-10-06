import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:provider/provider.dart';

import '../../Models/Notifiers/jobOffersNotifier.dart';
import '../../Models/job_offer_requests.dart';
import '../../Services/api.dart';
import '../RequestList/request_list.dart';

class JobOfferListPage extends StatefulWidget {
  const JobOfferListPage({super.key});

  @override
  State<JobOfferListPage> createState() => _JobOfferListPageState();
}

class _JobOfferListPageState extends State<JobOfferListPage> {
  List<JobOfferRequest> jobOfferRequests = [];

  _getMyJobOffers() async {
    jobOfferRequests = (await Api.getMyJobOffers())!;
    setState(() {
      jobOfferRequests.sort((a, b) => a.startingDate.compareTo(b.startingDate));
      jobOfferRequests = jobOfferRequests;
    });
    if (context.mounted) {
      var jobOfferProvider = context.read<JobOffersNotifier>();
      jobOfferProvider.addJobOfferList(jobOfferRequests);
    }
  }

  bool _jobRequestOngoing(JobOfferRequest jobOffer) {
    var now = DateTime.parse(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()));
    return jobOffer.startingDate.isBefore(now) &&
        jobOffer.startingDate
            .add(Duration(hours: jobOffer.workingHours))
            .isAfter(now);
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
          child: Consumer<JobOffersNotifier>(
            builder: (context, jobOffer, child) {
              return ListView.builder(
                itemCount: jobOffer.jobOffers.length +
                    1 +
                    (jobOffer.jobOffers.isEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: Text(
                          AppLocalizations
                              .of(context)
                              ?.jobOffersList_jobOffers ??
                              "Job Offers",
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                    );
                  } else {
                    if (jobOffer.jobOffers.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery
                                .of(context)
                                .size
                                .height / 3),
                        child: Center(
                          child: Text(
                            AppLocalizations
                                .of(context)
                                ?.jobOffersList_noJobsOffersYet ??
                                "No job offers yet 😢",
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RequestListPage(
                                      extraRequest:
                                      jobOffer.jobOffers[index - 1].requests,
                                      indexOfJobOffer: index - 1,
                                      jobOffer: jobOffer.jobOffers[index - 1]),
                            ),
                          );
                        },
                        child: Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  AppColors.accent,
                                  Color(0xFF008073),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            jobOffer.jobOffers[index - 1]
                                                .jobTitle,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            jobOffer.jobOffers[index - 1]
                                                .jobDescription,
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
                                    IconButton(
                                      onPressed: () {
                                        context.push(RequestListPage(
                                            extraRequest:
                                            jobOffer.jobOffers[index - 1]
                                                .requests,
                                            indexOfJobOffer: index - 1,
                                            jobOffer: jobOffer.jobOffers[index -
                                                1]));
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                if (_jobRequestOngoing(
                                    jobOffer.jobOffers[index - 1]))
                                  Positioned(
                                    bottom: 5,
                                    right: 0,
                                    child: Text(
                                        AppLocalizations
                                            .of(context)
                                            ?.jobOffersList_ongoing ??
                                            "Ongoing",
                                        style: const TextStyle(
                                          color: Colors.yellowAccent,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                        )),
                                  )
                              ],
                            )),
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
