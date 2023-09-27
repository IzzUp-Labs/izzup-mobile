import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Models/stats.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:provider/provider.dart';

import '../../Models/company.dart';
import '../../Models/globals.dart';
import '../../Models/homepage_card_data.dart';
import '../../Models/photo.dart';
import '../../Models/scale.dart';
import '../AddJobOffer/add_job_offer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<HomepageCardData> _forYouCards = [];
  final List<HomepageCardData> _newsCards = [];
  final List<HomepageCardData> _jobsCards = [];

  final double _cardHeight = 150;
  final double _cardWidth = 250;
  bool _profileLoaded = false;
  Company? _company;
  ExtraStats? extraStats;
  EmployerStats? employerStats;

  Widget _walletWidget() {
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 3,
          child: const Image(image: AssetImage("assets/wallet.png")),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (extraStats == null || extraStats?.finishedRequest == 0)
                  Text(
                    AppLocalizations.of(context)?.homeScreen_youDidNotEarnYet ??
                        "You must work a first gig to start earning some money !",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                if (extraStats != null && extraStats?.finishedRequest != 0)
                  Text(
                    AppLocalizations.of(context)?.homeScreen_youEarned ??
                        "You earned",
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                if (extraStats != null && extraStats?.finishedRequest != 0)
                  Text(
                    "${extraStats!.totalEarned.toString().split(".")[0]} €",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 32),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                if (extraStats != null && extraStats?.finishedRequest != 0)
                  Row(
                    children: [
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)?.homeScreen_with ??
                              'with ',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w800),
                          children: <TextSpan>[
                            TextSpan(
                                text: extraStats!.finishedRequest
                                    .toString()
                                    .split('.')[0],
                                style:
                                    const TextStyle(color: AppColors.accent)),
                            TextSpan(
                                text: AppLocalizations.of(context)
                                        ?.homeScreen_jobs ??
                                    ' jobs'),
                          ],
                        ),
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                      ),
                      const Spacer()
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget companyWidget() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30, top: 5),
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 2.75,
          child: Image.asset(
            'assets/business-vision.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (employerStats == null ||
                    employerStats?.totalFinishedJobRequests == 0)
                  Text(
                    AppLocalizations.of(context)?.homeScreen_noOffersYet ??
                        "No offers yet",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                if (employerStats != null &&
                    employerStats?.totalFinishedJobRequests != 0)
                  Text(
                    AppLocalizations.of(context)?.homeScreen_extras(
                            employerStats!.totalFinishedJobRequests.toInt()) ??
                        "Extras",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 32),
                  ),
                if (employerStats != null &&
                    employerStats?.totalFinishedJobRequests != 0)
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 6),
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)?.homeScreen_with ??
                            'with ',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                        children: <TextSpan>[
                          TextSpan(
                              text: employerStats!.totalJobOffers
                                  .toString()
                                  .split('.')[0],
                              style: const TextStyle(color: AppColors.accent)),
                          TextSpan(
                              text: AppLocalizations.of(context)
                                      ?.homeScreen_jobOffers ??
                                  ' job offers'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                if (_company != null)
                  ElevatedButton(
                    onPressed: () {
                      context.push(
                        AddJobOffer(
                            userId: Globals.profile!.id,
                            companyId: _company!.id),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.homeScreen_addOffer ??
                          "Add an offer",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _card(HomepageCardData data) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _cardHeight,
            width: _cardWidth,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.network(data.picLink ?? "", fit: BoxFit.fitWidth),
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Container(
              width: _cardWidth,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                data.title,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: _cardWidth,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                data.description,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionText(String assetName, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
      child: Row(
        children: [
          Image(
            image: AssetImage(assetName),
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _instantiateCards() async {
    final cards = await Api.homepageCards();
    HomepageCardData.groupByType(cards).forEach((key, value) {
      switch (key) {
        case HomepageCardType.jobs:
          setState(() {
            _jobsCards.addAll(value);
          });
          break;
        case HomepageCardType.news:
          setState(() {
            _newsCards.addAll(value);
          });
          break;
        case HomepageCardType.forYou:
          setState(() {
            _forYouCards.addAll(value);
          });
          break;
      }
    });
  }

  void _instantiateProfile() async {
    await Globals.loadProfile();
    if (Globals.profile?.role == UserRole.employer) {
      _company = (await Api.getCompaniesFromToken())?.first;
    }
    setState(() {
      _profileLoaded = true;
    });
  }

  void _initStats() async {
    if (Globals.profile?.role == UserRole.employer) {
      EmployerStats? employerStatsTemp = await Api.getStatsEmployer();
      setState(() => employerStats = employerStatsTemp);
    } else if (Globals.profile?.role == UserRole.extra) {
      ExtraStats? extraStatsTemp = await Api.getStatsExtra();
      setState(() => extraStats = extraStatsTemp);
    }
  }

  @override
  void initState() {
    super.initState();
    _instantiateCards();
    _instantiateProfile();
    _initStats();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.accent,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: HeaderClipper(),
                        child: CustomPaint(
                          size: Size.fromHeight(
                              MediaQuery.of(context).size.height / 2.5),
                          painter: HeaderPainter(color: AppColors.accent),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                7,
                                        decoration: const BoxDecoration(
                                            color: Colors.white38,
                                            shape: BoxShape.circle),
                                        child: Consumer<Photo>(
                                            builder: (context, photo, child) {
                                          return photo.photo != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                  child: Image.file(
                                                    photo.photo!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Globals.profile?.photo != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  100)),
                                                      child: Image.network(
                                                          Globals.profile
                                                                  ?.photo ??
                                                              "",
                                                          fit: BoxFit.cover),
                                                    )
                                                  : const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    );
                                        }),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_profileLoaded)
                                          Text(
                                            AppLocalizations.of(context)
                                                    ?.homeScreen_hi(Globals
                                                            .profile
                                                            ?.firstName ??
                                                        '') ??
                                                "Hi ${Globals.profile?.firstName ?? ''},",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18),
                                          ),
                                        if (_profileLoaded)
                                          Text(
                                            AppLocalizations.of(context)
                                                    ?.homeScreen_welcomeOnIzzUp ??
                                                "Welcome on IzzUp !",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      ],
                                    )
                                  ],
                                )),
                            Stack(
                              children: [
                                if (Globals.profile?.role ==
                                        UserRole.employer &&
                                    _company != null)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 35, right: 35),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                    5 +
                                                50,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            color: AppColors.accent,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(_company!.name,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    child: Column(
                                      children: [
                                        const Spacer(),
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 3,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Globals.profile?.role ==
                                                    UserRole.extra
                                                ? _walletWidget()
                                                : Globals.profile?.role ==
                                                        UserRole.employer
                                                    ? companyWidget()
                                                    : null),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_forYouCards.isEmpty &&
                      _newsCards.isEmpty &&
                      _jobsCards.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 5),
                        child: const Center(
                          child: Text(
                            "🏃 Loading data...",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  if (_forYouCards.isNotEmpty)
                    _sectionText(
                        "assets/notification_icon.png",
                        AppLocalizations.of(context)?.homeScreen_forYou ??
                            "For you"),
                  if (_forYouCards.isNotEmpty)
                    SizedBox(
                      height: _cardHeight + 50,
                      child: ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const SizedBox(width: 10),
                          for (var card in _forYouCards) _card(card),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  if (_newsCards.isNotEmpty)
                    _sectionText(
                        "assets/notification_icon.png",
                        AppLocalizations.of(context)?.homeScreen_news ??
                            "News"),
                  if (_newsCards.isNotEmpty)
                    SizedBox(
                      height: _cardHeight + 50,
                      child: ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const SizedBox(width: 10),
                          for (var card in _newsCards) _card(card),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  if (_jobsCards.isNotEmpty)
                    _sectionText(
                        "assets/notification_icon.png",
                        AppLocalizations.of(context)?.homeScreen_jobsNearMe ??
                            "Jobs near me"),
                  if (_jobsCards.isNotEmpty)
                    SizedBox(
                      height: _cardHeight + 50,
                      child: ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const SizedBox(width: 10),
                          for (var card in _jobsCards) _card(card),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height - 100)
      ..quadraticBezierTo(size.width / 4, (size.height - 50), size.width / 2,
          (size.height - 50))
      ..quadraticBezierTo(size.width - (size.width / 4), (size.height - 50),
          size.width, size.height - 100)
      ..lineTo(size.width, 0.0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class HeaderPainter extends CustomPainter {
  HeaderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height - 50);
    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarBounds =
        Rect.fromCircle(center: centerAvatar, radius: 50).inflate(3);
    _drawBackground(canvas, shapeBounds, avatarBounds);
  }

  @override
  bool shouldRepaint(HeaderPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect avatarBounds) {
    final paint = Paint()..color = color;

    final backgroundPath = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top)
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy)
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy)
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy)
      ..close();

    canvas.drawPath(backgroundPath, paint);
  }
}
