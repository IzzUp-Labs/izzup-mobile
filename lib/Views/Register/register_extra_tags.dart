import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/wave.dart';

class RegisterExtraTags extends StatefulWidget {
  const RegisterExtraTags({super.key});

  @override
  State<RegisterExtraTags> createState() => _RegisterExtraTagsState();
}

class _RegisterExtraTagsState extends State<RegisterExtraTags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
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
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: const Image(
                  image: AssetImage('assets/thumbsup.png'),
                  width: 290,
                ),
              ),
            ),
            const Spacer(),
            const Wave(),
          ],
        ),
      ),
    );
  }
}
