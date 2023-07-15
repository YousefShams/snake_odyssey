import 'package:flutter/material.dart';
import '../transition/page_transition.dart';

class AppRoutes {

  static final screens = {

  };

  static Widget getScreenFromRoute(String? route) {
    return screens[route] ?? const Scaffold();
  }

  static Route onGenerateRoute (RouteSettings route) {
    return PageTransition(getScreenFromRoute(route.name), setting: route);
  }

}