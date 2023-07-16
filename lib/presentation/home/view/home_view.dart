import 'package:flutter/material.dart';
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
              const Text("Snake Odyssey", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
              const SizedBox(height: 100),
              SizedBox(
                width: 120,
                child: FilledButton(onPressed: (){Navigator.push(context, PageTransition(const GameScreen()));},
                    child: const Text("Play", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 120,
                child: FilledButton(onPressed: (){Navigator.push(context, PageTransition(const SettingsScreen()));},
                  child: const Text("Settings", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
