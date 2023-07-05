import 'package:flutter/material.dart';

import '../../Models/user.dart';
import '../../Models/user_with_request.dart';
import '../../Services/api.dart';

class LastJobRequestListPage extends StatefulWidget {
  const LastJobRequestListPage({super.key});

  @override
  State<LastJobRequestListPage> createState() => _LastJobRequestListPageState();
}

class _LastJobRequestListPageState extends State<LastJobRequestListPage> {
  UserWithRequests userWithRequests = UserWithRequests.basic;

  _getExtraRequests() async {
    await Api.getExtraRequests().then((value) {
      if (value == null) return;
      setState(() {
        userWithRequests = value;
      });
    });
  }

  @override
  void initState() {
    _getExtraRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _getExtraRequests();
          },
          child: ListView.builder(
            itemCount: userWithRequests.requests.length +
                1 +
                (userWithRequests.requests.isEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Text("Job Requests",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                );
              } else {
                if (userWithRequests.requests.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 3),
                    child: const Text("No job requests yet 😢",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        )),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 10),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userWithRequests
                                .requests[index - 1].jobOffer.jobTitle,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userWithRequests
                                .requests[index - 1].jobOffer.jobDescription,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userWithRequests
                                .requests[index - 1].jobOffer.startingDate
                                .toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
