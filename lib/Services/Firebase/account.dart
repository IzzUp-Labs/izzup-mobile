import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:izzup/Services/modals.dart';

import '../navigation.dart';

class AccountNotificationHandler {
  static onAccountVerified() {
    if (kDebugMode) print('Account verified');
    final BuildContext? context = Navigation.navigatorKey.currentContext;
    if (context == null) return;
    context.popToHome();
  }

  static onAccountNotVerified() {
    if (kDebugMode) print('Account not verified');
    final BuildContext? context = Navigation.navigatorKey.currentContext;
    if (context == null) return;
    Modals.showModalNotValid();
  }
}
