import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:izzup/Views/SignIn/signin_landing.dart';
import 'package:izzup/Views/Welcoming/welcoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/location.dart';
import '../../Services/notifications.dart';

enum WelcomingPageType {
  landing,
  localisation,
  notifications;

  Future<void> onInit() async {
    switch (this) {
      case WelcomingPageType.localisation:
        await Prefs.setBool('hasSeenIntro', true);
        break;
      default:
        break;
    }
  }

  String title() {
    switch (this) {
      case WelcomingPageType.landing:
        return "Welcome on IzzUp";
      case WelcomingPageType.localisation:
        return "Find gigs near you";
      case WelcomingPageType.notifications:
        return "Receive job offers in real-time";
    }
  }

  String subtitle() {
    switch (this) {
      case WelcomingPageType.landing:
        return "We are here to help you find offers in your area";
      case WelcomingPageType.localisation:
        return "Your location helps us locate the offers that you might be able to go to in the shortest time possible";
      case WelcomingPageType.notifications:
        return "Enable notifications to be alerted of new offers or accepted requests";
    }
  }

  String assetImageName() {
    switch (this) {
      case WelcomingPageType.landing:
        return 'assets/welcome_landing.png';
      case WelcomingPageType.localisation:
        return 'assets/welcome_localisation.png';
      case WelcomingPageType.notifications:
        return 'assets/welcome_notifications.png';
    }
  }

  String buttonTitle() {
    switch (this) {
      case WelcomingPageType.landing:
        return 'Next';
      case WelcomingPageType.localisation:
        return 'Enable location ?';
      case WelcomingPageType.notifications:
        return 'Enable notifications ?';
    }
  }

  double pageNumber() {
    switch (this) {
      case WelcomingPageType.landing:
        return 0;
      case WelcomingPageType.notifications:
        return 1;
      case WelcomingPageType.localisation:
        return 2;
    }
  }

  Future<void> onBtnTapped(BuildContext context, Widget widget,
      {bool firstClick = true}) async {
    switch (this) {
      case WelcomingPageType.landing:
        _landingBtnTapped(context, widget);
        break;
      case WelcomingPageType.localisation:
        _localisationBtnTapped(context, widget);
        break;
      case WelcomingPageType.notifications:
        _notificationsBtnTapped(context, widget);
        break;
    }
  }

  void _landingBtnTapped(BuildContext context, Widget widget) {
    context.navigateWithTransition(
      widget,
      const Welcoming(pageType: WelcomingPageType.notifications),
    );
  }

  Future<void> _localisationBtnTapped(
      BuildContext context, Widget widget) async {
    print(await LocationService.getLocation());
    if (context.mounted) {
      context.navigateWithTransition(widget, const SignIn());
    }
  }

  Future<void> _notificationsBtnTapped(
      BuildContext context, Widget widget) async {
    await Notifications.requestNotificationPermission(context);
    if (context.mounted) {
      context.navigateWithTransition(
          widget, const Welcoming(pageType: WelcomingPageType.localisation));
    }
  }
}
