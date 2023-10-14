import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Models/globals.dart';
import '../../Models/scale.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';

class ProfileRecapScreen extends StatefulWidget {
  const ProfileRecapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileRecapScreenState();
}

class _ProfileRecapScreenState extends State<ProfileRecapScreen> {
  bool _isLoading = true;
  File? image;

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
                          ?.profileRecapTitle ??
                          "Profile",
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
                      ignoreGestures: true,
                      initialRating: 0, //TODO: recup du profil
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
                        //Obligatoire pour que le widget fonctionne
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

}