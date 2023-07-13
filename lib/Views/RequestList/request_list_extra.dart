import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Models/job_offer_requests.dart';
import 'package:izzup/Services/api.dart';

import '../../Services/colors.dart';

class RequestListExtra extends StatefulWidget {
  const RequestListExtra({super.key});

  @override
  State<RequestListExtra> createState() => _RequestListExtraState();
}

class _RequestListExtraState extends State<RequestListExtra> {
  List<JobRequestWithVerificationCode> requests = [];

  bool _isLoading = true;
  String? authToken;

  _getMyRequests() {
    setState(() {
      _isLoading = true;
    });
    Api.getExtraRequests().then((value) {
      if (value == null) return;
      setState(() {
        _isLoading = false;
        var sortedRequests = value.requests;
        sortedRequests.sort((a, b) =>
            a.jobOffer.startingDate.compareTo(b.jobOffer.startingDate));
        requests = sortedRequests;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getMyRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _getMyRequests();
          },
          child: ListView.builder(
            itemCount: requests.length + 1 + (requests.isEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 10),
                  child: Text(
                      AppLocalizations.of(context)
                              ?.requestListExtra_requestSent ??
                          "Requests sent",
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                );
              } else {
                if (requests.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 3),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)
                                ?.requestListExtra_noRequestsYet ??
                            "No requests sent yet 😢",
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
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
                                  requests[index - 1].company.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM - HH:mm').format(
                                      requests[index - 1]
                                          .jobOffer
                                          .startingDate),
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
                          Icon(
                            getIconFromStatus(requests[index - 1].status),
                            color: Colors.white,
                          ),
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

  IconData getIconFromStatus(JobRequestStatus status) {
    switch (status) {
      case JobRequestStatus.pending:
        return Icons.timer_outlined;
      case JobRequestStatus.accepted:
        return Icons.check_circle;
      case JobRequestStatus.rejected:
        return Icons.cancel_outlined;
      case JobRequestStatus.waitingForVerification:
        return Icons.ac_unit;
      case JobRequestStatus.finished:
        return Icons.done_all_outlined;
      default:
        return Icons.timer_outlined;
    }
  }
}
