import 'package:flutter/material.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/Register/register_id_card.dart';
import 'package:gig/Views/Welcoming/welcoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/Home/home.dart';
import 'Views/SignIn/signin_landing.dart';
import 'Views/Welcoming/welcoming_page_type.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var hasSeenIntro = prefs.getBool('hasSeenIntro');
  var isLoggedIn = prefs.getString("userId") != null;

  runApp(IzzUp(
    hasSeenIntro: hasSeenIntro,
    isLoggedIn: isLoggedIn,
  ));
}

class IzzUp extends StatefulWidget {
  const IzzUp(
      {super.key, required this.hasSeenIntro, required this.isLoggedIn});

  final bool? hasSeenIntro;
  final bool isLoggedIn;

  @override
  State<IzzUp> createState() => _IzzUpState();
}

class _IzzUpState extends State<IzzUp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.dropFocus(),
        child: MaterialApp(
            title: 'IzzUp',
            theme: ThemeData(
              primarySwatch: AppColors.accentMaterialColor,
            ),
            home: widget.hasSeenIntro != true
                ? const Welcoming(pageType: WelcomingPageType.landing)
                : !widget.isLoggedIn
                    ? const Home(title: 'Home')
                    : const SignIn()
            ));
  }
}
