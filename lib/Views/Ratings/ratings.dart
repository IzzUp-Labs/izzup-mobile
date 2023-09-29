import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/navigation.dart';

import '../../Models/badges.dart';
import '../../Models/rating.dart';
import '../../Models/scale.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.userId});

  final String userId;

  @override
  State<StatefulWidget> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  bool _isLoading = true;
  File? image;
  double opacity = 1.0;
  bool clicked = false;
  User ratedUser = User.basic;
  bool isExtra = Globals.profile?.role != UserRole.extra;
  int stars = 0;

  List<Badges> badges = [];
  List<String> selectedBadges = [];
  Rating rating = Rating.basic;

  @override
  void initState() {
    super.initState();
    _getBadges();
    _getUser();
  }

  _getUser() async {
    var user = await Api.getProfileById(widget.userId);
    if (user != null) {
      setState(() {
        ratedUser = user;
        _isLoading = false;
      });
    }
  }

  _getBadges() async {
    var badges = await Api.getBadges();
    if (badges != null) {
      setState(() {
        this.badges = badges.where((element) =>
        isExtra ? element.is_extra : !element.is_extra
        ).toList();
      });
    }
  }

  _createRating() async {
    setState(() => _isLoading = true);
    rating.stars = stars != 0 ? stars : null;
    rating.targetId = ratedUser.id;
    rating.badges = badges.isNotEmpty ? selectedBadges : null;
    await Api.rateUser(rating);
    if (context.mounted) context.popToHome();
  }

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
                      AppLocalizations.of(context)?.ratingTitle ??
                          "Rating",
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
                      decoration: BoxDecoration(
                          color: (image == null && ratedUser.photo == null) ? const Color(0xFFe0e0e0) : Colors.white38,
                          shape: BoxShape.circle,
                          border: const Border.fromBorderSide(
                              BorderSide(
                                  color: Colors.grey,
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
                            : ratedUser.photo == null
                            ? const Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                            : Image.network(
                            ratedUser.photo ?? "",
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ratedUser.firstName,
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(
                          ratedUser.lastName,
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
                    Text(
                        AppLocalizations.of(context)?.howWasYourTime ??
                            "How was your time ?",
                        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        textScaleFactor: ScaleSize.textScaleFactor(context)
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 7.0),
                      itemBuilder: (context, _) =>
                      const Icon(
                        Icons.star,
                        color: AppColors.accent,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          stars = rating.toInt();
                        });
                      },
                    ),
                    const SizedBox(height: 50),
                    Text(
                      AppLocalizations.of(context)?.profile_badges ?? "Badges:",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context)?.tapOnBadge ??
                          "Tap on a badge to add it",
                      style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 175,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var badge in badges) _badge(badge),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _createRating();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02c18a),
                          foregroundColor: AppColors.accent,
                          fixedSize: const Size(150, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30), // <-- Radius
                          )),
                      child: Text(
                        AppLocalizations.of(context)?.ratingRate ??
                            "Rate",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              if(badge.clicked) {
                selectedBadges.add(badge.id);
              } else {
                selectedBadges.remove(badge.id);
              }
              setState(() {});
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: badge.opacity,
              child: Image.network(
                badge.image,
                width: badge.clicked ? 120 : 100,
                height: badge.clicked ? 120 : 100,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Flexible(
            child: Text(
                Globals.isLangFrench() ? badge.nameFr : badge.nameEn,
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