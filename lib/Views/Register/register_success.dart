import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Home/home.dart';

import '../../Models/wave.dart';

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({super.key});

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  void _loadProfileAndNavigate() async {
    await Globals.loadProfile();
    Timer(const Duration(milliseconds: 750), () {
      context.navigateWithoutBack(const Home());
    });
  }

  @override
  void initState() {
    _loadProfileAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                      width: 70,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    AppLocalizations.of(context)
                            ?.register_thankYouForJoiningIzzUp ??
                        "Thank you for joining IzzUp !",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                const Wave(),
              ],
            ),
            Column(
              children: [
                const Spacer(),
                Center(
                  child: Image(
                    image: const AssetImage('assets/employee_of_the_month.png'),
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                const SizedBox(height: 100),
                const ClassyLoader(
                    loaderBackground: Colors.transparent,
                    loaderSize: 30,
                ),
                const Spacer()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
