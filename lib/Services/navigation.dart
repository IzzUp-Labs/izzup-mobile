import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension Navigation on BuildContext {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void dropFocus() {
    FocusScope.of(this).unfocus();
  }

  void push(Widget widget) {
    dropFocus();
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void navigateWithTransition(
    Widget currWidget,
    Widget nextPage, {
    PageTransitionType transitionType = PageTransitionType.rightToLeftJoined,
  }) {
    dropFocus();
    Navigator.push(
      this,
      PageTransition(
        type: transitionType,
        child: nextPage,
        childCurrent: currWidget,
      ),
    );
  }

  void navigateWithoutBack(Widget nextPage) {
    Navigator.pushAndRemoveUntil<dynamic>(
      this,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => nextPage,
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }
}
