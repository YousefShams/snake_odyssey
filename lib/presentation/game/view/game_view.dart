import 'package:flutter/material.dart';
import 'package:snake/presentation/game/view/components/game_map.dart';
import '../view_model/game_view_model.dart';
import 'components/game_score.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final vm = GameViewModel();


  void changeSnakePosition() {
    setState(() {
      vm.changeSnakePosition(vm.playerSnake.direction,
          vm.playerSnake.position, context, vm.foodPosition);
    });
  }

  void update() {
    vm.update(changeSnakePosition, () {  setState(() { vm.bulletUpdates(); }); });
  }

  @override
  void initState() {
    update();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    vm.generateRandomFood(vm.playerSnake.position,vm.getTileCounts(context));
    vm.tileCounts = vm.getTileCounts(context);
    super.didChangeDependencies();
  }

  void setStateCallback(callback) {
    setState(() {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        children: [
          GameMap(vm: vm, setState: setStateCallback),
          GameScore(
            score: vm.playerSnake.getScore(),
            gameOver: vm.isGameOver(),
            restart: () {
              setState(() {
                vm.reset(context);
                update();
              });
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    vm.dispose();
  }
}
