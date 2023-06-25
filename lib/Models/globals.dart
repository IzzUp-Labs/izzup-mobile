import 'package:camera/camera.dart';
import 'package:izzup/Services/prefs.dart';

import 'company.dart';
import 'employer.dart';
import 'extra.dart';

class Globals {
  static Company tempCompany = Company.basic;
  static Extra tempExtra = Extra.basic;
  static Employer tempEmployer = Employer.basic;
  static late CameraDescription firstCamera;
  static String authToken = '';

  static initFirstCamera() async {
    firstCamera = (await availableCameras()).first;
  }

  static setUserFromExtra() {
    Prefs.setString('userEmail', tempExtra.email);
    Prefs.setString('userPwd', tempExtra.password);
  }
}