import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izzup/Services/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
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

class _HomeScreenState extends State<HomeScreen> {

  final List<MaterialColor> _forYouCards = [Colors.red, Colors.blue, Colors.cyan, Colors.yellow];
  final List<MaterialColor> _newsCards = [Colors.orange, Colors.grey, Colors.green, Colors.yellow];
  final List<MaterialColor> _jobsCards = [Colors.yellow, Colors.cyan, Colors.green, Colors.red];

  final double _cardHeight = 150;
  final double _cardWidth = 250;
  bool _isLoading = true;

  final Widget _walletWidget = Row(
    children: [
      SizedBox(
        height: WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height / 6,
        width: WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / 6,
        child: const Image(image: AssetImage("assets/wallet.png")),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You earned",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                ),
              ),
              const Text(
                "2,124 €",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  RichText(
                    text: const TextSpan(
                      text: 'with ',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.w800
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '24', style: TextStyle(color: AppColors.accent)),
                        TextSpan(text: ' jobs'),
                      ],
                    ),
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

  Widget _card(CardData data) {
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
              child: CachedNetworkImage(
                  imageUrl: 'https://googleflutter.com/sample_image.jpg',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  fit: BoxFit.fitWidth
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              data.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              data.description,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12
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

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 5 * 1000), () {
      setState(() {
        _isLoading = false;
      });
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
                          size: Size.fromHeight(MediaQuery.of(context).size.height / 2.5),
                          painter: HeaderPainter(color: AppColors.accent),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 7,
                                        height: MediaQuery.of(context).size.width / 7,
                                        decoration: const BoxDecoration(
                                            color: Colors.white38,
                                            shape: BoxShape.circle
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width / 7)),
                                          child: CachedNetworkImage(
                                              imageUrl: 'https://googleflutter.com/sample_image.jpg',
                                              placeholder: (context, url) => const CircularProgressIndicator(),
                                              fit: BoxFit.fitWidth
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Hi ${"Adrien"},",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18
                                          ),
                                        ),
                                        Text(
                                          "Welcome on IzzUp !",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 5,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  Container(
                                      height: MediaQuery.of(context).size.height / 6,
                                      width: MediaQuery.of(context).size.width - 40,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.8),
                                            blurRadius: 3,
                                            offset: const Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: _walletWidget
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _sectionText("assets/notification_icon.png", "For you"),
                  SizedBox(
                    height: _cardHeight + 50,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        for (var card in _forYouCards)
                          _card(CardData("Title", "Description", "pictureData", "type", "link", "companyId")),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  _sectionText("assets/notification_icon.png", "News"),
                  SizedBox(
                    height: _cardHeight + 50,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        for (var card in _newsCards)
                          _card(CardData("Title", "Description", "pictureData", "type", "link", "companyId")),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  _sectionText("assets/notification_icon.png", "Jobs near me"),
                  SizedBox(
                    height: _cardHeight + 50,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        for (var card in _jobsCards)
                          _card(CardData("Title", "Description", "pictureData", "type", "link", "companyId")),
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
      ..quadraticBezierTo(
          size.width / 4, (size.height - 50),
          size.width / 2, (size.height - 50)
      )
      ..quadraticBezierTo(
          size.width - (size.width / 4), (size.height - 50),
          size.width, size.height - 100
      )
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
  HeaderPainter({ required this.color });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height - 50);
    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarBounds = Rect.fromCircle(center: centerAvatar, radius: 50).inflate(3);
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