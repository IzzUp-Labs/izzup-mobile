import 'package:camera/camera.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:location/location.dart';

import 'company.dart';
import 'employer.dart';
import 'extra.dart';

class Globals {
  static Company tempCompany = Company.basic;
  static Extra tempExtra = Extra.basic;
  static Employer tempEmployer = Employer.basic;
  static late CameraDescription firstCamera;
  static LocationData? locationData;
  static User? profile;
  static bool profileLoaded = false;

  static authToken() async {
    return await Prefs.getString('authToken');
  }

  static loadProfile() async {
    profileLoaded = false;
    profile = await Api.getProfile();
    profileLoaded = true;
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
}
