import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/Home/home.dart';

import '../../Models/wave.dart';

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({super.key});

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1 * 1000), () {
      context.navigateWithoutBack(const Home(title: "Home Page"));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
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
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Thank you for joining IzzUp !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: const Image(
                  image: AssetImage('assets/thumbsup.png'),
                  width: 290,
                ),
              ),
            ),
            const Spacer(),
            const Wave(),
          ],
        ),
      ),
    );
  }
}
