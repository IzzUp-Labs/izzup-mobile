import 'package:flutter/cupertino.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../Services/colors.dart';

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        colors: [const Color(0xFF0081A7), AppColors.accent],
        durations: [5000, 6000],
        heightPercentages: [0.65, 0.66],
      ),
      size: const Size(double.infinity, 200),
      waveAmplitude: 3,
    );
  }
}
