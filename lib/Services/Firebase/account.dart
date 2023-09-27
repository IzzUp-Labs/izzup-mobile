import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../navigation.dart';

class AccountNotificationHandler {
  static onAccountVerified() {
    if (kDebugMode) print('Account verified');
    final BuildContext? context = Navigation.navigatorKey.currentContext;
    if (context == null) return;
    Navigator.of(context).pop();
  }
}
