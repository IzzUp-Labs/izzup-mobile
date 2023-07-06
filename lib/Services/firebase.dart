import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:izzup/Views/HomeScreen/home_screen.dart';
import 'package:izzup/main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
    print(message.notification?.title);
    print(message.notification?.body);
    print(message.data);
  }

}

class FirebaseApi {
  final _firebaseMessaging =  FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('Token: $fcmToken');
    }
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}