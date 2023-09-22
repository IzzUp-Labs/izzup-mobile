import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/scale.dart';

class EmailAwaitingVerificationPage extends StatefulWidget {
  const EmailAwaitingVerificationPage({super.key});

  @override
  State<EmailAwaitingVerificationPage> createState() => _EmailAwaitingVerificationPageState();
}

class _EmailAwaitingVerificationPageState extends State<EmailAwaitingVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.confirm_email ??
                          "Awaiting email verification",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 50),
                    Image.asset("assets/awaiting_email_verification.png", height: 200),
                    const SizedBox(height: 50),
                    Text(
                      AppLocalizations.of(context)?.confirm_email_directions ??
                          "Check your inbox for a verification email.",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

}