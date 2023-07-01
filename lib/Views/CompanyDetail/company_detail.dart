import 'package:flutter/material.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  // Liste des offres d'emploi
  List<String> jobOffers = [
    'Job Offer 1',
    'Job Offer 2',
    'Job Offer 3',
    'Job Offer 4',
  ];

  @override
  void initState() {
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Company Name'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // tab bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF00B096),
              tabs: const [
                Tab(
                  text: 'About',
                ),
                Tab(
                  text: 'Jobs',
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
                            const SizedBox(width: 10), // Espacement entre l'image et le texte
                            // Description de l'entreprise
                            const Expanded(
                              child: Text(
                                'Description de l\'entreprise',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Espacement entre la description de l'entreprise et la ligne
                        // Ligne verte
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: const Color(0xFF00B096),
                        ),
                        const SizedBox(height: 10), // Espacement entre la ligne et la description de l'employeur
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
                    itemCount: jobOffers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(jobOffers[index]),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Action lorsque le bouton est pressé
                              // Ajoutez ici votre code pour la demande d'emploi
                              print('Demande d\'emploi pour ${jobOffers[index]}');
                            },
                            child: const Text('Postuler'),
                          ),
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