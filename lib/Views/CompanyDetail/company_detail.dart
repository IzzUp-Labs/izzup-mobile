import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Services/api.dart';
import 'package:provider/provider.dart';

import '../../Models/company.dart';
import '../../Models/Notifiers/jobRequestNotifier.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key, required this.company});

  final Company company;

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with SingleTickerProviderStateMixin {
  _splitDate(String date) {
    final splitted = date.split(': ');
    String openingHours = splitted[1].split('–')[0];
    openingHours = DateFormat("HH:mm").parse(openingHours.trim()).toString();
    openingHours = DateFormat("HH:mm").format(DateTime.parse(openingHours));
    String closingHours = splitted[1].split('–')[1];
    closingHours = DateFormat("HH:mm").parse(closingHours.trim()).toString();
    closingHours = DateFormat("HH:mm").format(DateTime.parse(closingHours));
    return "${openingHours}h - ${closingHours}h";
  }

  String companyPhoto = "";
  Map<String, dynamic> _companyDetails = {};
  late TabController _tabController;
  int _currentTab = 0;

  final List<String> _appliedJobOffers = [];

  _applyToJobOffer(String jobOfferId) async {
    bool isApplied = await Api.applyToJobOffer(jobOfferId);
    if (isApplied) {
      setState(() {
        _appliedJobOffers.add(jobOfferId);
      });
      if(context.mounted) {
        var requestProvider = context.read<JobRequestWithVerificationCodeNotifier>();
        var requests = await Api.getExtraRequests();
        requestProvider.addJobRequestList(requests?.requests ?? []);
      }
    }
  }

  _getCompanyDetails() async {
    var result = await Api.getPlaceDetails(widget.company.placeId);
    setState(() {
      if (result != null) {
        _companyDetails = result;
      }
    });
    var googlePhoto = await Api.getPlacePhotoLinks(widget.company.placeId);
    setState(() {
      if (googlePhoto != null) {
        companyPhoto = googlePhoto.first;
      }
    });
  }

  @override
  void initState() {
    _getCompanyDetails();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B096), // Couleur de l'app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.company.name), // Nom de l'entreprise
      ),
      body: SafeArea(
        child: Column(
          children: [
            // tab bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF00B096),
              tabs: [
                Tab(
                  text: AppLocalizations.of(context)?.companyDetails_about ??
                      'About',
                ),
                Tab(
                  text: AppLocalizations.of(context)?.companyDetails_jobs ??
                      'Jobs',
                ),
              ],
            ),
            // tab bar view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Column(
                      children: [
                        companyPhoto == ""
                            ? const CircularProgressIndicator()
                            : Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF00B096),
                                    width: 2,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Color(0xFF00B096),
                                      Color(0xFF008073),
                                    ],
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    companyPhoto,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFF00B096)),
                              const SizedBox(width: 10),
                              Text(widget.company.address),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _companyDetails['formatted_phone_number'] != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.phone,
                                        color: Color(0xFF00B096)),
                                    const SizedBox(width: 10),
                                    Text(_companyDetails[
                                        'formatted_phone_number']),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        _companyDetails['opening_hours'] != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Color(0xFF00B096)),
                                    const SizedBox(width: 10),
                                    Text(_splitDate(
                                        _companyDetails['opening_hours']
                                                ['weekday_text']
                                            [DateTime.now().weekday - 1])),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        // Espacement entre la description de l'entreprise et la ligne
                        // Ligne verte
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: const Color(0xFF00B096),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.company.jobOffers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF00B096),
                                    width: 2,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Color(0xFF00B096),
                                      Color(0xFF008073),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        widget
                                            .company.jobOffers[index].jobTitle,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        widget.company.jobOffers[index]
                                            .jobDescription,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        height: double.infinity,
                                        child: IconButton(
                                          icon: Icon(
                                            _appliedJobOffers.contains(widget
                                                    .company
                                                    .jobOffers[index]
                                                    .id)
                                                ? Icons.check_circle
                                                : Icons.add_circle_outline,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          title: Center(
                                                              child: Text(AppLocalizations.of(
                                                                          context)
                                                                      ?.companyDetails_beforeApplying ??
                                                                  "Before applying")),
                                                          content: Text(
                                                            AppLocalizations.of(context)?.companyDetails_areYouSure(
                                                                    widget
                                                                        .company
                                                                        .jobOffers[
                                                                            index]
                                                                        .jobTitle,
                                                                    DateFormat.Hm().format(widget
                                                                        .company
                                                                        .jobOffers[
                                                                            index]
                                                                        .startingDate)) ??
                                                                "Are you sure you want to apply ?",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () => Navigator.pop(
                                                                  context,
                                                                  AppLocalizations.of(
                                                                              context)
                                                                          ?.companyDetails_cancel ??
                                                                      "Cancel"),
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                              context)
                                                                          ?.companyDetails_cancel ??
                                                                      "Cancel",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                final alreadyApplied =
                                                                    _appliedJobOffers.contains(widget
                                                                        .company
                                                                        .jobOffers[
                                                                            index]
                                                                        .id);
                                                                final id = widget
                                                                    .company
                                                                    .jobOffers[
                                                                        index]
                                                                    .id;
                                                                if (id !=
                                                                        null &&
                                                                    !alreadyApplied) {
                                                                  _applyToJobOffer(
                                                                      id);
                                                                } else if (alreadyApplied) {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        AppLocalizations.of(context)?.companyDetails_alreadyApplied ??
                                                                            "Already applied"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                                Navigator.pop(
                                                                    context,
                                                                    AppLocalizations.of(context)
                                                                            ?.companyDetails_apply ??
                                                                        "Apply");
                                                              },
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                              context)
                                                                          ?.companyDetails_apply ??
                                                                      "Apply",
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF00B096))),
                                                            ),
                                                          ],
                                                          elevation: 24.0,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20.0))),
                                                        ));
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
