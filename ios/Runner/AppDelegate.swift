import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
	  FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyA0OV0UsfJbZXDg5GKvWgHhuRC5iDqlw_g")
    GeneratedPluginRegistrant.register(with: self)
	  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
