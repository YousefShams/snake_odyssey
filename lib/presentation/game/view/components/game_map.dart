import 'package:flutter/material.dart';
import 'package:snake/app/enums/snake_direction.dart';
import 'package:snake/presentation/game/view_model/game_view_model.dart';

import 'game_score.dart';

class GameMap extends StatefulWidget {
  const GameMap({Key? key}) : super(key: key);

  @override
  State<GameMap> createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {

  final vm = GameViewModel();


  void changeSnakePosition() {
    setState(() {
      vm.setPositions(vm.changeSnakePosition(vm.direction, vm.snakePosition, context, vm.foodPosition));
    });
  }

  @override
  void initState() {
    vm.setPositions(vm.getInitialSnakePosition(context));
    vm.update(changeSnakePosition);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    vm.generateRandomFood(vm.snakePosition,vm.getTileCounts(context));
    vm.tileCounts = vm.getTileCounts(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              // Get the direction of the drag
              Offset delta = details.delta;
              double dx = delta.dx;
              double dy = delta.dy;
              if (dx.abs() > dy.abs()) {
                // The drag is horizontal
                if (dx > 0) {
                  // Drag to the right
                  setState(() {
                    vm.direction = vm.changeDirection(Direction.RIGHT, vm.direction);
                  });
                } else {
                  // Drag to the left
                  setState(() {
                    vm.direction = vm.changeDirection(Direction.LEFT, vm.direction);
                  });
                }
              } else {
                // The drag is vertical
                if (dy > 0) {
                  setState(() {
                    vm.direction = vm.changeDirection(Direction.DOWN, vm.direction);
                  });
                } else {
                  // Drag up
                  setState(() {
                    vm.direction = vm.changeDirection(Direction.UP, vm.direction);
                  });
                }
              }
            },
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: vm.crossAxisCount, mainAxisSpacing: vm.crossAxisSpacing,
                    crossAxisSpacing: vm.crossAxisSpacing
                ),

                itemCount: vm.getTileCounts(context),
                itemBuilder: (context, index) => vm.getTileWidget(index, vm.snakePosition, vm.foodPosition)
            ),
          ),
        ),
        GameScore(
          score: vm.score,
          gameOver: vm.isGameOver(vm.snakePosition, vm.snakeLength),
          restart: () {
            setState(() {
              vm.reset(context);
              vm.update(changeSnakePosition);
            });
          },
        )
      ],
    );
  }
}
