import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/Firebase/job_requests.dart';
import 'package:izzup/Services/api.dart';

import '../../Models/job_offer_requests.dart';

void handleForegroundMessage(RemoteMessage message) {
  if (kDebugMode) {
    print('Handling a foreground message (${message.messageId})'
        '\n${message.notification?.title}'
        '\n${message.notification?.body}'
        '\n${message.data}');

    switch (message.data['type']) {
      case 'account_verified':
        break;
      case 'job-request-accepted':
        JobRequestNotificationHandler.onJobRequestAccepted(
            JobOfferRequest.fromJson(jsonDecode(message.data['job_offer'])));
        break;
      case 'job-request-confirmed':
        final json = jsonDecode(message.data['job_request']);
        JobRequestNotificationHandler.onJobRequestConfirmed(
            json['verification_code'], json['request_id']);
        break;
      case 'job-request-finished':
        JobRequestNotificationHandler.onJobRequestFinished();
        break;
    }
  }
}

void handleMessageOpenedApp(RemoteMessage message) {
  if (kDebugMode) {
    print('Handling a opened message (${message.messageId})'
        '\n${message.notification?.title}'
        '\n${message.notification?.body}'
        '\n${message.data}');
  }
}

Future<void> handleTerminatedMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message (${message.messageId})'
        '\n${message.notification?.title}'
        '\n${message.notification?.body}'
        '\n${message.data}');
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  setupHandlers() {
    FirebaseMessaging.onMessage
        .listen(handleForegroundMessage); // Message received when in foreground
    FirebaseMessaging.onMessageOpenedApp
        .listen(handleMessageOpenedApp); // Message received when app is opened
    FirebaseMessaging.onBackgroundMessage(
        handleTerminatedMessage); // Message received when terminated
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    final status = (await _firebaseMessaging.getNotificationSettings())
        .authorizationStatus;
    String? deviceId = await Globals.getId();

    if (status == AuthorizationStatus.authorized &&
        deviceId != null &&
        fcmToken != null) {
      if (kDebugMode) print("Sending token");
      Api.changeFcmToken(deviceId, fcmToken);
    }

    if (kDebugMode) print("$deviceId $fcmToken");

    if (status != AuthorizationStatus.authorized && deviceId != null) {
      Api.changeFcmToken(deviceId, '');
    }

    if (!Globals.firebaseHandlersSet) {
      setupHandlers();
      Globals.firebaseHandlersSet = true;
    }
  }
}
