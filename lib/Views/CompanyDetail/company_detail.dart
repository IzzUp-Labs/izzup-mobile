import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Services/api.dart';
import '../../Models/company.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key, required this.company});

  final Company company;

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  final List<int> _appliedJobOffers = [];

  _applyToJobOffer(int jobOfferId) async {
    bool isApplied = await Api.applyToJobOffer(jobOfferId);
    if(isApplied) {
      setState(() {
        _appliedJobOffers.add(jobOfferId);
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
      if (kDebugMode) print(_appliedJobOffers.contains(widget.company.jobOffers[0].id));
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
        title: Text( widget.company.name ), // Nom de l'entreprise
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
                  text: AppLocalizations.of(context)?.companyDetails_about ?? 'About',
                ),
                Tab(
                  text: AppLocalizations.of(context)?.companyDetails_jobs ?? 'Jobs',
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
                        Row(
                          children: [
                            // Photo de l'entreprise
                            Image.network(
                              'https://toohotel.com/wp-content/uploads/2022/09/TOO_restaurant_Panoramique_vue_Paris_nuit_v2-scaled.jpg',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(width: 10),
                            // Espacement entre l'image et le texte
                            // Description de l'entreprise
                            const Expanded(
                              child: Text(
                                'Description de l\'entreprise',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Espacement entre la description de l'entreprise et la ligne
                        // Ligne verte
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: const Color(0xFF00B096),
                        ),
                        const SizedBox(height: 10),
                        // Espacement entre la ligne et la description de l'employeur
                        // Photo de profil de l'employeur
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://www.sdp.ulaval.ca/blogue/wp-content/uploads/2017/10/shutterstock_343001735-bien-choisir-employeur-blogue-768x530.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Texte décrivant l'employeur
                        const Text(
                          'Description de l\'employeur',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.company.jobOffers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(widget.company.jobOffers[index].jobTitle),
                          subtitle: Text(widget.company.jobOffers[index].jobDescription),
                          trailing: _appliedJobOffers.contains(widget.company.jobOffers[index].id) == false ? ElevatedButton(
                            onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Center(child: Text(AppLocalizations.of(context)?.companyDetails_beforeApplying ?? "Before applying")),
                              content: Text(
                                AppLocalizations.of(context)?.companyDetails_areYouSure(widget.company.jobOffers[index].jobTitle, DateFormat.Hm().format(widget.company.jobOffers[index].startingDate)) ??
                                    "Are you sure you want to apply ?",
                                  textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, AppLocalizations.of(context)?.companyDetails_cancel ?? "Cancel"),
                                  child: Text(AppLocalizations.of(context)?.companyDetails_cancel ?? "Cancel", style: const TextStyle(color: Colors.red)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final id = widget.company.jobOffers[index].id;
                                    if (id != null) {
                                      _applyToJobOffer(id);
                                    }
                                    Navigator.pop(context, AppLocalizations.of(context)?.companyDetails_apply ?? "Apply");
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)?.companyDetails_apply ?? "Apply",
                                      style: const TextStyle(color: Color(0xFF00B096))
                                  ),
                                ),
                              ],
                              elevation: 24.0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ),
                            child: Text(AppLocalizations.of(context)?.companyDetails_apply ?? "Apply"),
                          ) :
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B096),
                                  ),
                                  child: Text(AppLocalizations.of(context)?.companyDetails_applied ?? "Applied"))
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
