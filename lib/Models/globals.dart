import 'dart:async';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Services/Firebase/app_notifications.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:location/location.dart';

import '../Services/modals.dart';
import '../Views/SignIn/signin_landing.dart';
import 'company.dart';
import 'employer.dart';
import 'extra.dart';
import 'job_offer_requests.dart';

class Globals {
  static bool firebaseHandlersSet = false;
  static Company tempCompany = Company.basic;
  static Extra tempExtra = Extra.basic;
  static Employer tempEmployer = Employer.basic;
  static late CameraDescription firstCamera;
  static LocationData? locationData;
  static User? profile;
  static bool profileLoaded = false;
  static bool isWelcomeLoading = false;

  static ValueNotifier<List<UserVerificationStatus>?> profileStatusNotifier = ValueNotifier<List<UserVerificationStatus>?>(profile?.statuses);

  static authToken() async {
    return await Prefs.getString('authToken');
  }

  static loadProfile() async {
    profileLoaded = false;
    profile = await Api.getProfile();
    profileLoaded = true;
    await FirebaseApi().initNotifications();
  }

  static checkProfileStatus() async {
    loadProfile();
    if (Globals.profile?.status == UserVerificationStatus.verified) {
      if (Globals.profile == null) return;
      if (Globals.profile?.role == UserRole.extra) {
        Api.getExtraRequests().then((value) {
          if (value == null) return;
          var requests = value.requests.where((element) =>
          element.status == JobRequestStatus.waitingForVerification);
          if (requests.isNotEmpty && requests.first.verificationCode != null) {
            Modals.showJobEndModalExtra(
                requests.first.verificationCode!, requests.first.id!);
          }
        });
      } else {
        Api.getMyJobOffers().then((value) {
          if (value == null) return;
          var requestsFromJobOffers =
          value.map((e) => e.requests).expand((element) => element).toList();
          var requests = requestsFromJobOffers.where((element) =>
          JobRequestStatus.fromString(element.status) ==
              JobRequestStatus.waitingForVerification);
          if (requests.isNotEmpty) {
            for (var element in requests) {
              if (element.id == null) continue;
              Modals.showJobEndModalEmployer(element.id!);
            }
          }
        });
      }
    } else {
      Timer(const Duration(milliseconds: 750), () {
        switch(Globals.profile?.status) {
          case UserVerificationStatus.unverified:
            Modals.showModalNeedsVerification();
            break;
          case UserVerificationStatus.needsId:
            Modals.showModalNeedsId();
            break;
          case UserVerificationStatus.notValid:
            Modals.showModalNotValid();
            break;
          default:
            break;
        }
      });
    }
  }

  static initFirstCamera() async {
    firstCamera = (await availableCameras()).first;
  }

  static setUserFromExtra() {
    Prefs.setString('userEmail', tempExtra.email);
    Prefs.setString('userPwd', tempExtra.password);
  }

  static initLocation() async {
    Location location = Location();
    locationData = await location.getLocation();
  }

  static Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      try {
        return await androidIdPlugin.getId();
      } on PlatformException {
        if (kDebugMode) print('Failed to get Android ID.');
        return Future.value(null);
      }
    }
    return null;
  }

  static String getLocale() {
    return Platform.localeName.split('_')[0] == 'fr' ? 'fr' : 'en';
  }

  static logout() async {
    if (await Api.logout()) {
      Prefs.remove("authToken");
      Prefs.remove("userEmail");
      Prefs.remove("userPwd");
      Navigation.navigatorKey.currentContext?.navigateWithoutBack(const SignIn());
    }
  }

  static deleteAccount() async {
    if (await Api.deleteAccount()) {
      Prefs.remove("authToken");
      Prefs.remove("userEmail");
      Prefs.remove("userPwd");
      Navigation.navigatorKey.currentContext?.navigateWithoutBack(const SignIn());
    }
  }
}
