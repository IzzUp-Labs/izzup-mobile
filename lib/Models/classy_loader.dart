import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassyLoader extends StatelessWidget {
  final Color loaderColor;
  final double loaderSize;

  const ClassyLoader(
      {super.key,
      this.loaderColor = const Color(0xFF00B096),
      this.loaderSize = 48.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
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
    );
  }
}
