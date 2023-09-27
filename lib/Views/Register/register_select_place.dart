import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/company.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Register/register_id_card.dart';

import '../../Models/globals.dart';
import '../../Models/place.dart';
import '../../Models/wave.dart';
import '../../Services/api.dart';
import '../../Services/prefs.dart';

class RegisterSelectPlaceRoute extends PageRouteBuilder {
  final Place place;
  final List<String>? photoLinks;

  RegisterSelectPlaceRoute(this.place, this.photoLinks)
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                RegisterSelectPlace(place: place, photoLinks: photoLinks));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(0, 1), end: const Offset(.0, .0))
              .animate(controller as Animation<double>),
      child: RegisterSelectPlace(place: place, photoLinks: photoLinks),
    );
  }
}

class RegisterSelectPlace extends StatefulWidget {
  const RegisterSelectPlace(
      {super.key, required this.place, required this.photoLinks});

  final Place place;
  final List<String>? photoLinks;

  @override
  State<RegisterSelectPlace> createState() => _RegisterSelectPlaceState();
}

class _RegisterSelectPlaceState extends State<RegisterSelectPlace> {
  bool _isLoading = false;

  void _onYesPressed() async {
    setState(() => _isLoading = true);
    Globals.tempEmployer.company = Company(
        '0', widget.place.name, widget.place.placeId, widget.place.address, []);
    Globals.tempEmployer.location = widget.place.location;

    if (await Api.registerAndLoginEmployer()) {
      Prefs.setString('userEmail', Globals.tempEmployer.email);
      Prefs.setString('userPwd', Globals.tempEmployer.password);
      if (context.mounted) context.navigateWithoutBack(const RegisterIdCard());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.add_business_rounded,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)?.register_isThisYourBusiness ??
                        "Is this your business ?",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    widget.place.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.place.address,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CarouselSlider(
                    items: widget.photoLinks?.map<Widget>((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(i))));
                            },
                          );
                        }).toList() ??
                        [],
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      fixedSize: const Size(200, 50),
                    ),
                    onPressed: () async {
                      _onYesPressed();
                    },
                    child: Text(
                      AppLocalizations.of(context)?.register_yesThatsMe ??
                          "Yes, that's me!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      fixedSize: const Size(200, 50),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)
                              ?.register_thisIsNotMyBusiness ??
                          'This is not my business',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Expanded(child: Wave()),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const ClassyLoader(),
      ],
    );
  }
}
