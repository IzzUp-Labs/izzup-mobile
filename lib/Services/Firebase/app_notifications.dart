import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/Firebase/account.dart';
import 'package:izzup/Services/Firebase/job_requests.dart';
import 'package:izzup/Services/api.dart';

import '../../Models/job_offer_requests.dart';

void handleForegroundMessage(RemoteMessage message) {
  if (kDebugMode) {
    print('Handling a foreground message (${message.messageId})'
        '\n${message.notification?.title}'
        '\n${message.notification?.body}'
        '\n${message.data}');
  }

  switch (message.data['type']) {
    case 'account_verified':
      AccountNotificationHandler.onAccountVerified();
      break;
    case 'account_not_verified':
      AccountNotificationHandler.onAccountNotVerified();
      break;
    case 'job-request-accepted':
      String date = message.data['starting_date'];
      date = date.substring(1, date.length - 1);
      JobRequestNotificationHandler.onJobRequestAccepted(
          message.data['job_title'], date);
      break;
    case 'job-request-confirmed':
      print(message.data['user_id']);
      JobRequestNotificationHandler.onJobRequestConfirmed(
          message.data['verification_code'], message.data['request_id'], message.data['user_id']);
      break;
    case 'job-request-finished':
      JobRequestNotificationHandler.onJobRequestFinished(message.data['user_id']);
      break;
  }
}

void handleMessageOpenedApp(RemoteMessage message) {
  if (kDebugMode) {
    print('Handling a opened message (${message.messageId})'
        '\n${message.notification?.title}'
        '\n${message.notification?.body}'
        '\n${message.data}');
  }
  switch (message.data['type']) {
    case 'account_verified':
      AccountNotificationHandler.onAccountVerified();
      break;
    case 'account_not_verified':
      AccountNotificationHandler.onAccountNotVerified();
      break;
    case 'job-request-accepted':
      String date = message.data['starting_date'];
      date = date.substring(1, date.length - 1);
      JobRequestNotificationHandler.onJobRequestAccepted(
          message.data['job_title'], date);
      break;
    case 'job-request-confirmed':
      print(message.data['user_id']);
      JobRequestNotificationHandler.onJobRequestConfirmed(
          message.data['verification_code'], message.data['request_id'], message.data['user_id']);
      break;
    case 'job-request-finished':
      JobRequestNotificationHandler.onJobRequestFinished(message.data['user_id']);
      break;
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
    if (deviceId != null) {
      Api.changeFcmToken(
          deviceId,
          fcmToken ?? '',
          status == AuthorizationStatus.authorized
      );
    }

    if (!Globals.firebaseHandlersSet) {
      setupHandlers();
      Globals.firebaseHandlersSet = true;
    }
  }
}
