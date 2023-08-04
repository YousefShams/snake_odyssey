import 'package:flutter/material.dart';
import 'package:snake/app/resources/app_strings.dart';
import 'package:snake/presentation/how_to_play/view/how_to_play_view.dart';
import 'package:snake/presentation/settins/view/settings_view.dart';
import '../../../app/transition/page_transition.dart';
import '../../game/view/game_view.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(AppStrings.appTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
              const SizedBox(height: 100),
              SizedBox(
                width: 140,
                child: FilledButton(onPressed: (){Navigator.push(context, PageTransition(const GameScreen()));},
                    child: Text(AppStrings.play, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 140,
                child: FilledButton(onPressed: (){Navigator.push(context, PageTransition(const SettingsScreen()));},
                  child: Text(AppStrings.settingsTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 140,
                child: FilledButton(onPressed: (){Navigator.push(context, PageTransition(const HowToPlayScreen()));},
                  child: Text(AppStrings.howTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        mini: true,
        onPressed: () { Navigator.push(context, PageTransition(const HowToPlayScreen())); },
        child: const Icon(Icons.question_mark_rounded),
      ),
    );
  }
}
