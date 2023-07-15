
// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/app/enums/snake_direction.dart';

class GameViewModel {
  int score = 0;
  final int crossAxisCount = 20;
  final double mainAxisSpacing = 5.0;
  final double crossAxisSpacing = 5.0;
  final double gridHeightFactor = 0.9;
  int initialSnakeLength = 4;
  int snakeLength = 4;
  late List<int> snakePosition;
  late int foodPosition;
  Timer? loop;
  DateTime prevMovement = DateTime.now();
  int? tileCounts;

  Direction direction = Direction.DOWN;

  int getTileCounts(context) {
    double tileHeight = (MediaQuery.of(context).size.width - ((crossAxisCount-1)*
        crossAxisSpacing))/crossAxisCount;

    double rowNum = ((MediaQuery.of(context).size.height*gridHeightFactor) -
        MediaQuery.of(context).padding.top) / (tileHeight+mainAxisSpacing);

    return crossAxisCount  * rowNum.ceil();
  }

  Widget getTileWidget(int index, List<int> snakePosition, int foodPosition) {
    final gameOver = isGameOver(snakePosition, snakeLength);
    final Color color;

    if(snakePosition.contains(index) && snakePosition.first != index && !gameOver) {
      color = Colors.white;
    }

    else if(snakePosition.contains(index) &&  snakePosition.first != index && gameOver) {
      color = Colors.redAccent;
    }

    else if(foodPosition == index) color = Colors.green;
    else if (snakePosition.first == index) color = Colors.lightBlueAccent;
    else color =  Colors.blueGrey.withOpacity(0.25);

    final distance = calculateDistanceBetweenPoints(snakePosition.first, foodPosition);
    final max = getMaxDistance(foodPosition, tileCounts);
    final result = (max-distance)/max;
    final opacity = result < 0.85 ? result * 0.4 : result;
    return AnimatedOpacity(
      opacity: (foodPosition==index) ?  (opacity<0.2) ? 0.2 : opacity : 1,
      duration: const Duration(milliseconds: 0),
      child: Container(
        alignment: const Alignment(0,0.5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(crossAxisCount/7),
        ),
        child: (snakePosition.first == index) ?
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(backgroundColor: Colors.pinkAccent, radius: 2,),
            CircleAvatar(backgroundColor: Colors.pinkAccent, radius: 2,)
          ],
        ) : null,
      ),
    );
  }

  int calculateDistanceBetweenPoints(int point1, int point2) {
    final difference = (point1 - point2).abs();
    final xDistance = ((point1 % crossAxisCount) - (point2 % crossAxisCount)).abs();
    final yDistance = (difference / crossAxisCount).round();
    return (xDistance) + (yDistance);
  }

  int getMaxDistance(int point, tileCounts) {
    final double mainAxisCount = tileCounts / crossAxisCount;
    double diff = mainAxisCount - (point/crossAxisCount).ceil();
    final maxY = max(diff, mainAxisCount-diff).ceil();
    final maxX = max(point % crossAxisCount, crossAxisCount-(point % crossAxisCount));
    return (maxX + maxY).ceil();
  }

  List<int> getInitialSnakePosition(context) {
    List<int> snakePosition = [110,90,70,50];
    return snakePosition;
  }

  void reset(context) {
    disposeUpdate();
    score = 0;
    direction = Direction.DOWN;
    snakeLength = initialSnakeLength;
    snakePosition = getInitialSnakePosition(context);
    generateRandomFood(snakePosition, getTileCounts(context));
  }

  void generateRandomFood(List<int> snakePosition, tilesCount) {
    int index = Random().nextInt(tilesCount);
    while(snakePosition.contains(index)) {
      index = Random().nextInt(tilesCount);
    }
    foodPosition = index;
  }

  void update(Function setStateFunction) {
    loop = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setStateFunction();
    });
  }

  void disposeUpdate() {
    loop = null;
  }

  void setPositions(pos) {
    snakePosition = pos.toList();
  }

  List<int> changeSnakePosition(Direction direction, List<int> snakePosition, context, foodPos) {
    List<int> newPosition = [];
    final tilesCount = getTileCounts(context);

    handleMovement(crossAxisCount, tilesCount, newPosition);
    eat(newPosition, tilesCount);
    handleGameOver(newPosition, snakeLength);

    return newPosition;
  }

  void handleMovement(int crossAxisCount, int tilesCount, newPosition) {
    int i = 0;
    for(int previousPosition in snakePosition) {
      if(i==0) {
        final int result;

        if(previousPosition%crossAxisCount == 0 && direction == Direction.LEFT) {
          result = previousPosition + crossAxisCount-1;
        }
        else if((previousPosition+1) % crossAxisCount == 0 && direction == Direction.RIGHT) {

          result = previousPosition - crossAxisCount+1;
        }
        else if((previousPosition >=0 && previousPosition <= crossAxisCount-1)
            && direction == Direction.UP) {

          result = previousPosition - crossAxisCount + tilesCount;
        }
        else if((previousPosition >= tilesCount-1-crossAxisCount && previousPosition <= tilesCount-1)
            && direction == Direction.DOWN) {
          result = previousPosition%(crossAxisCount);
        }
        else {
          final int factor;
          if(direction == Direction.UP) factor = -20;
          else if(direction == Direction.DOWN) factor = 20;
          else if(direction == Direction.RIGHT) factor = 1;
          else factor = -1;
          result = factor+previousPosition;
        }
        newPosition.add(result);
      }
      else {
        newPosition.add(snakePosition[i-1]);
      }
      i++;
    }
  }

  void eat(newPosition,tilesCount) {
    if(snakePosition.contains(foodPosition)) {
      newPosition.add(snakePosition.last);
      snakeLength+=1;
      score = (snakeLength - initialSnakeLength)*10;
      generateRandomFood(newPosition, tilesCount);
    }

  }


  bool isGameOver(newPositions, snakeLength) {
    return newPositions.toSet().length != snakeLength;
  }

  void handleGameOver(List<int> newPositions, snakeLength) {
    if(isGameOver(newPositions, snakeLength)) loop?.cancel();
  }

  Direction changeDirection(Direction newDir, Direction prevDir) {
    if(newDir == Direction.LEFT && prevDir == Direction.RIGHT) return prevDir;
    else if(newDir == Direction.RIGHT && prevDir == Direction.LEFT) return prevDir;
    else if(newDir == Direction.UP && prevDir == Direction.DOWN) return prevDir;
    else if(newDir == Direction.DOWN && prevDir == Direction.UP) return prevDir;

    if(DateTime.now().difference(prevMovement).inMilliseconds > 300) {
      prevMovement = DateTime.now();
      prevDir = newDir;
      return newDir;
    }
    else {
      return prevDir;
    }
  }
}