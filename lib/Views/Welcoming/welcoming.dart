import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Views/Welcoming/welcoming_page_type.dart';

class Welcoming extends StatefulWidget {
  const Welcoming({super.key, required this.pageType});

  final WelcomingPageType pageType;

  @override
  State<Welcoming> createState() => _WelcomingState();
}

class _WelcomingState extends State<Welcoming> {
  @override
  void initState() {
    widget.pageType.onInit();
    super.initState();
  }

  bool isFirstClick = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                    width: 70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.pageType.title(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Text(
                  widget.pageType.subtitle(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Image(
                image: AssetImage(widget.pageType.assetImageName()),
                width: 500,
              ),
              const Spacer(),
              DotsIndicator(
                dotsCount: 3,
                position: widget.pageType.pageNumber(),
                decorator: const DotsDecorator(
                  color: Colors.grey, // Inactive color
                  activeColor: AppColors.accent,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(left: 22, right: 22),
                child: ElevatedButton(
                  onPressed: () {
                    widget.pageType
                        .onBtnTapped(context, widget, firstClick: isFirstClick);
                    isFirstClick = false;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: Text(widget.pageType.buttonTitle()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
