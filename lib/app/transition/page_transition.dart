import 'package:flutter/material.dart';

class PageTransition extends PageRouteBuilder {
  final dynamic page;
  final RouteSettings? setting;

  PageTransition(this.page, {this.setting}) : super(
    settings: setting,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, animationTwo) => page,
    transitionsBuilder: (context, animation, animationTwo, child) {
      //final tween = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
      final animCurve = CurvedAnimation(parent: animation,curve: Curves.linearToEaseOut);
      return FadeTransition(opacity: animCurve, child: page);
    },

  );

}