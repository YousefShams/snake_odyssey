import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snake/app/resources/app_strings.dart';
import 'package:snake/presentation/splash/view/splash_view.dart';
import '../resources/app_themes.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: AppThemes.getTheme(),
      darkTheme: AppThemes.getDarkTheme(),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      //onGenerateRoute: AppRoutes.onGenerateRoute,
      //onGenerateInitialRoutes: (_)=> [PageTransition(AppRoutes.getScreenFromRoute(AppRoutes.splashRoute))]
    );
  }
}
