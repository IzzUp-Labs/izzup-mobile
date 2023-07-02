import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Views/Discussions/discussions_page.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class CardData {
  String title;
  String description;
  String? pictureData;
  String type;
  String? link;
  String? companyId;

  CardData(this.title, this.description, this.pictureData, this.type, this.link,
      this.companyId);
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;

  Widget _sectionText(String assetName, String text, String arrowAssetName) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: AssetImage(assetName),
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Image(
                image: AssetImage(arrowAssetName),
                height: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 60, right: 60),
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        )
      ],
    );
  }

  User? user;

  void _loadUser() async {
    user = await Api.getProfile();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    setState(() {
      _isLoading = false;
    });
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
                            const Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: Row()),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 2.7,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  Text(
                                    "${user?.firstName} ${user?.lastName}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: const BoxDecoration(
                                          color: Colors.white38,
                                          shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3)),
                                        child: _isLoading
                                            ? null
                                            : CachedNetworkImage(
                                                imageUrl: user?.idPhoto ?? "",
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DiscussionPage())
                            );},
                            child: const Text("test", style: TextStyle(color: Colors.black))),
                        _sectionText(
                            "assets/badge.png",
                            AppLocalizations.of(context)?.homeProfile_reviews ??
                                "Reviews",
                            "assets/arrow_right.png"),
                        _sectionText(
                            "assets/badge.png",
                            AppLocalizations.of(context)?.homeProfile_aboutMe ??
                                "About me",
                            "assets/arrow_right.png"),
                        _sectionText(
                            "assets/badge.png",
                            AppLocalizations.of(context)
                                    ?.homeProfile_myContracts ??
                                "My contracts",
                            "assets/arrow_right.png"),
                        _sectionText(
                            "assets/badge.png",
                            AppLocalizations.of(context)
                                    ?.homeProfile_myLastJobs ??
                                "My last jobs",
                            "assets/arrow_right.png"),
                        const SizedBox(
                          height: 50,
                        )
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
        )
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
