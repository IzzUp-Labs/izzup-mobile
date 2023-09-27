import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Services/Firebase/app_notifications.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:location/location.dart';

import 'company.dart';
import 'employer.dart';
import 'extra.dart';

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

  static authToken() async {
    return await Prefs.getString('authToken');
  }

  static loadProfile() async {
    profileLoaded = false;
    profile = await Api.getProfile();
    profileLoaded = true;
    await FirebaseApi().initNotifications();
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
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      try {
        return await androidIdPlugin.getId();
      } on PlatformException {
        print('Failed to get Android ID.');
        return Future.value(null);
      }
    }
    return null;
  }

  static String getLocale() {
    return Platform.localeName.split('_')[0] == 'fr' ? 'fr' : 'en';
  }
}
