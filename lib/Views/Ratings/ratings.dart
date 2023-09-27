import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/badges.dart';
import '../../Models/globals.dart';
import '../../Models/scale.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  bool _isLoading = true;
  File? image;
  double opacity = 1.0;
  bool clicked = false;

  List<Badges> badges = [
    Badges('1', 'Ponctuel', 'assets/wallet.png'),
    Badges('2', 'Amical', 'assets/thumbsup.png'),
    Badges('3', 'Extraverti', 'assets/badge.png'),
    Badges('4', 'badge4', 'assets/work_time.png'),
    Badges('5', 'badge5', 'assets/job_hunter.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          ?.ratingTitle ??
                          "Rate the extra",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width:
                      MediaQuery.of(context).size.width / 3,
                      height:
                      MediaQuery.of(context).size.width / 3,
                      decoration: const BoxDecoration(
                          color: Colors.white38,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                              BorderSide(
                                  color: Colors.white,
                                  width: 10))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(
                                MediaQuery.of(context)
                                    .size
                                    .width /
                                    3)),
                        child: _isLoading
                            ? null
                            : image != null
                            ? Image.file(image!,
                            fit: BoxFit.cover)
                            : user?.photo == null
                            ? const Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                            : Image.network(
                            user?.photo ?? "",
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user?.firstName ?? "FirstName",
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Text(
                          user?.lastName ?? "LastName",
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)
                          ?.ratingScore ??
                          "Score:",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 7.0),
                      itemBuilder: (context, _) =>
                      const Icon(
                        Icons.star,
                        color: AppColors.accent,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating); //TODO: stocker dans l'objet pour un envoi
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Badges:",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var badge in badges)
                            _badge(badge),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }

  User? user;

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    final fetchedUser = await Api.getProfile();
    setState(() {
      user = fetchedUser;
      Globals.profile = fetchedUser;
      _isLoading = false;
    });
  }

  Widget _badge(Badges badge) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              badge.opacity = badge.clicked ? 0.4 : 1;
              badge.clicked = !badge.clicked;
              print(badge.opacity);
              print(badge.clicked);
              print("Tapped");
              setState(() {});
              print(badge.opacity);
              print(badge.clicked);
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: badge.opacity,
              child: Image.asset(
                badge.image,
                width: badge.clicked ? 120 : 100,
                height: badge.clicked ? 120 : 100,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(5)),
          Flexible(
            child: Text(
              badge.name,
              softWrap: true,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
            ),
          )
        ],
      ),
    );
  }

}