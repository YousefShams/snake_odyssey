import 'package:flutter/material.dart';
import 'package:snake/app/transition/page_transition.dart';
import 'package:snake/presentation/home/view/home_view.dart';
import '../../../app/resources/app_assets.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) =>
                AnimatedOpacity(
                  opacity: value,
                  duration: const Duration(seconds: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.logo, width: 100),
                      const SizedBox(height: 20),
                      const Text("Snake Odyssey", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
                    ],
                  ),
                )
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6),
            (){Navigator.pushReplacement(context, PageTransition(const HomeScreen()));}
    );
  }

}
