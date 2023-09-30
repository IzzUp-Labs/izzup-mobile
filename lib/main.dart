import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Models/Notifiers/jobOffersNotifier.dart';
import 'package:izzup/Models/extra.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/Firebase/app_notifications.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:provider/provider.dart';
import 'package:izzup/firebase_options.dart';

import 'Models/Notifiers/jobRequestNotifier.dart';
import 'Models/photo.dart';
import 'Views/Home/home.dart';
import 'Views/SignIn/signin_landing.dart';
import 'Views/Welcoming/welcoming.dart';
import 'Views/Welcoming/welcoming_page_type.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var hasSeenIntro = await Prefs.getBool('hasSeenIntro');
  var isLoggedIn = await _renewTokenIfPossible();
  Globals.initFirstCamera();

  if (hasSeenIntro == true) {
    await FirebaseApi().initNotifications();
  }

  if (await Prefs.getBool('locationServiceEnabled') ?? false) {
    await Globals.initLocation();
  }

  if (isLoggedIn) {
    await Globals.loadProfile();
  }

  runApp(IzzUp(
    hasSeenIntro: hasSeenIntro,
    isLoggedIn: isLoggedIn,
  ));
}

Future<bool> _renewTokenIfPossible() async {
  String? email = await Prefs.getString('userEmail');
  String? pwd = await Prefs.getString('userPwd');
  if (email != null && pwd != null) {
    return await Api.login(Extra(email, pwd, DateTime.now()));
  } else {
    Prefs.remove('userEmail');
    Prefs.remove('userPwd');
    return false;
  }
}

class IzzUp extends StatefulWidget {
  const IzzUp(
      {super.key, required this.hasSeenIntro, required this.isLoggedIn});

  final bool? hasSeenIntro;
  final bool isLoggedIn;

  @override
  State<IzzUp> createState() => _IzzUpState();
}

class _IzzUpState extends State<IzzUp> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _renewTokenIfPossible();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Photo>(
            create: (_) => Photo()),
        ChangeNotifierProvider<JobRequestWithVerificationCodeNotifier>(
            create: (_) => JobRequestWithVerificationCodeNotifier()),
        ChangeNotifierProvider<JobOffersNotifier>(
            create: (_) => JobOffersNotifier()),
      ],
      child: GestureDetector(
          onTap: () => context.dropFocus(),
          child: MaterialApp(
              navigatorKey: Navigation.navigatorKey,
              title: AppLocalizations.of(context)?.appName ?? 'IzzUp',
              theme: ThemeData(
                fontFamily: 'Cera Pro SV',
                primarySwatch: AppColors.accentMaterialColor,
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: widget.hasSeenIntro != true
                    ? const Welcoming(pageType: WelcomingPageType.landing)
                    : widget.isLoggedIn
                    ? const Home()
                    : const SignIn(),
              ))),
    );
  }
}