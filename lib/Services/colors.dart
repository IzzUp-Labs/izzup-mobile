import 'package:flutter/material.dart';

extension AppColors on Color {
  static const accent = Color(0xFF00b096);

  static Map<int, Color> accentColorMap = {
    50: accent.withOpacity(.1),
    100: accent.withOpacity(.2),
    200: accent.withOpacity(.3),
    300: accent.withOpacity(.4),
    400: accent.withOpacity(.5),
    500: accent.withOpacity(.6),
    600: accent.withOpacity(.7),
    700: accent.withOpacity(.8),
    800: accent.withOpacity(.9),
    900: accent.withOpacity(1),
  };

  static MaterialColor accentMaterialColor =
      MaterialColor(0x0000b096, accentColorMap);
  static MaterialAccentColor accentMaterialAccentColor =
      MaterialAccentColor(0x0000b096, accentColorMap);
}
