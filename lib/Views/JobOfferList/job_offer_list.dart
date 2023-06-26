import 'package:flutter/material.dart';

import '../../Models/job_offer_requests.dart';
import '../../Services/api.dart';
import '../RequestList/request_list.dart';

class JobOfferListPage extends StatefulWidget {
  const JobOfferListPage({super.key});

  @override
  State<JobOfferListPage> createState() => _JobOfferListPageState();
}

class _JobOfferListPageState extends State<JobOfferListPage> {

  List<JobOfferRequests> jobOfferRequests = [];

  _getMyJobOffers() async {
    jobOfferRequests = (await Api.getMyJobOffers())!;
    setState(() {
      jobOfferRequests = jobOfferRequests;
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
        child: ListView.builder(
          itemCount: jobOfferRequests.length,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF00B096),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF00B096),
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
                          jobOfferRequests[index].jobTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          jobOfferRequests[index].jobDescription,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestListPage(extraRequest: jobOfferRequests[index].requests),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  ),
                ],
              )
            );
          },
        ),
      ),
    );
  }

}