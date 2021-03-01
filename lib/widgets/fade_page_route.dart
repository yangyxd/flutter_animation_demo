import 'package:flutter/material.dart';

/// 淡入淡出效果
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget widget;

  FadePageRoute({this.widget, RouteSettings settings}): super(
      transitionDuration: const Duration(milliseconds: 500),
      settings: settings,
      pageBuilder: (context, ani1, ani2) {
        return widget;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child)
      {
        return FadeTransition(opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation1,
            curve: Curves.easeInOut
        )), child: child);
      }
  );

}