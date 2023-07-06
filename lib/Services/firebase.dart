import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
}

class FirebaseApi {
  final _firebaseMessaging =  FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}