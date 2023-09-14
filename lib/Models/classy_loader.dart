import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassyLoader extends StatelessWidget {
  final Color loaderColor;
  final double loaderSize;
  final Color loaderBackground;

  const ClassyLoader(
      {super.key,
      this.loaderColor = const Color(0xFF00B096),
      this.loaderSize = 20.0,
      this.loaderBackground = Colors.black54});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: loaderSize,
      height: loaderSize,
      child: Container(
        color: loaderBackground,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
            strokeWidth: 4.0,
            backgroundColor: Colors.white,
            value: null,
            semanticsLabel:
                AppLocalizations.of(context)?.loader_loading ?? 'Loading',
            semanticsValue:
                AppLocalizations.of(context)?.loader_loading ?? 'Loading',
          ),
        ),
      ),
    );
  }
}
