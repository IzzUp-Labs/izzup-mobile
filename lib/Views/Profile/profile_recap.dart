import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Models/badges.dart';
import '../../Models/globals.dart';
import '../../Models/rating.dart';
import '../../Models/scale.dart';
import '../../Models/user.dart';
import '../../Models/user_stats.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';
import '../../Services/prefs.dart';

class ProfileRecapScreen extends StatefulWidget {
  const ProfileRecapScreen({super.key, required this.fromProfile, required this.id});

  final bool fromProfile;
  final String id;

  @override
  State<StatefulWidget> createState() => _ProfileRecapScreenState();
}

class _ProfileRecapScreenState extends State<ProfileRecapScreen> {
  bool _isLoading = true;
  File? image;
  double opacity = 1.0;
  bool clicked = false;
  User ratedUser = User.basic;
  bool isExtra = false;
  int stars = 0;
  UserStats userStats = UserStats.basic;
  double average = 0.0;

  bool success = false;

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  _getInfo() async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return null;
    final id = JwtDecoder.decode(authToken)['id'];
    if(widget.fromProfile) {
      _getUser(id);
      _getUserStats(id);
    } else {
      _getUser(widget.id);
      _getUserStats(widget.id);
    }
  }

  _getUser(String id) async {
    var user = await Api.getProfileById(id);
    if (user != null) {
      setState(() {
        ratedUser = user;
        _isLoading = false;
      });
    }
  }

  _getUserStats(String id) async {
    var requestStats = await Api.getUserStats(id);
    if (requestStats != null) {
      setState(() {
        userStats = requestStats;
        if(requestStats.average != null) {
          average = requestStats.average!;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                          Icons.arrow_back_ios
                      )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          ?.profileRecapTitle ??
                          "Profile Recap",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userStats.average != null ? userStats.average!.toStringAsFixed(2) : '0',
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " (${userStats.total})",
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
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      ignoreGestures: true,
                      initialRating: average,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
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
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var badge in userStats.badges)
                            _badge(badge),
                        ],
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

  User? user;

  Widget _badge(Badges badge) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: badge.ratingCount! > 0 ? 1.0 : badge.opacity,
            child: Stack(
              children: [
                Image.network(
                  badge.image,
                  width: 100,
                  height: 100,
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badge.ratingCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                )
              ],
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