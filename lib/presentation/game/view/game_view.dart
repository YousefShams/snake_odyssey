import 'package:flutter/material.dart';
import 'package:snake/presentation/game/view/components/game_map.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.black,
      child: GameMap(),
    );
  }
}
