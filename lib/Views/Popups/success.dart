import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessPopup extends StatefulWidget {
  const SuccessPopup({super.key});

  @override
  State<SuccessPopup> createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            )).blurred(
            blur: 10,
            blurColor: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            overlay: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.white54,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)?.success ?? 'Success',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
