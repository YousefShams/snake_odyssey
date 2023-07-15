import 'package:flutter/material.dart';
import 'package:snake/presentation/game/view/game_view.dart';
import '../constants/constants.dart';
import '../resources/app_themes.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: AppThemes.getTheme(),
      darkTheme: AppThemes.getDarkTheme(),
      themeMode: ThemeMode.system,
      home: const GameScreen(),
      //onGenerateRoute: AppRoutes.onGenerateRoute,
      //onGenerateInitialRoutes: (_)=> [PageTransition(AppRoutes.getScreenFromRoute(AppRoutes.splashRoute))]
    );
  }
}
