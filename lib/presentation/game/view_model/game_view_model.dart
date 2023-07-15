
// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/app/constants/constants.dart';
import 'package:snake/app/enums/snake_direction.dart';
import 'package:snake/domain/models/snake_model.dart';

class GameViewModel {
  Snake playerSnake = Snake();
  Snake? enemySnake = Snake(direction: Direction.RIGHT, position: [5,4,3,2,1]);
  Timer? gameLoop;
  Timer? bulletLoop;
  int foodPosition = 15;
  bool shouldBulletEat = false;
  DateTime lastDirectionChange = DateTime.now();
  DateTime lastEnemyChange = DateTime.now();
  int? tileCounts;

  int getTileCounts(context) {
    double tileHeight = (MediaQuery.of(context).size.width - ((AppConstants.crossAxisCount-1)*
        AppConstants.crossAxisSpacing))/AppConstants.crossAxisCount;

    double rowNum = ((MediaQuery.of(context).size.height*AppConstants.gridHeightFactor) -
        MediaQuery.of(context).padding.top) / (tileHeight+AppConstants.mainAxisSpacing);

    return AppConstants.crossAxisCount  * rowNum.ceil();
  }

  Color getTileColor(int index) {
    final gameOver = isGameOver();
    Color color =  Colors.blueGrey.withOpacity(0.25);

    if(enemySnake!=null) {
      if(enemySnake!.position.contains(index)) return Colors.red;
    }

    if(playerSnake.position.contains(index) && playerSnake.position.first != index && !gameOver) {
      color = Colors.white;
    }

    else if(playerSnake.position.contains(index) &&  playerSnake.position.first != index && gameOver) {
      color = Colors.redAccent;
    }

    else if(index == playerSnake.bulletPosition) color = Colors.deepOrange;

    else if(foodPosition == index) color = Colors.green;
    else if (playerSnake.position.first == index) color = Colors.lightBlueAccent;
    else color =  Colors.blueGrey.withOpacity(0.25);

    return color;
  }

  double getTileOpacity(int index) {
    final distance = calculateDistanceBetweenPoints(playerSnake.position.first, foodPosition);
    final max = getMaxDistance(foodPosition, tileCounts);
    final result = (max-distance)/max;
    final opacity = result < 0.85 ? result * 0.4 : result;
    return opacity;
  }

  int calculateDistanceBetweenPoints(int point1, int point2) {
    final difference = (point1 - point2).abs();
    final xDistance = ((point1 % AppConstants.crossAxisCount) - (point2 % AppConstants.crossAxisCount)).abs();
    final yDistance = (difference / AppConstants.crossAxisCount).round();
    return (xDistance) + (yDistance);
  }

  int getMaxDistance(int point, tileCounts) {
    final double mainAxisCount = tileCounts / AppConstants.crossAxisCount;
    double diff = mainAxisCount - (point/AppConstants.crossAxisCount).ceil();
    final maxY = max(diff, mainAxisCount-diff).ceil();
    final maxX = max(point % AppConstants.crossAxisCount, AppConstants.crossAxisCount-(point % AppConstants.crossAxisCount));
    return (maxX + maxY).ceil();
  }

  List<int> getInitialSnakePosition(context) {
    List<int> snakePosition = [110,90,70,50];
    return snakePosition;
  }

  void reset(context) {
    disposeUpdate();
    playerSnake.resetSnake();
    enemySnake?.resetSnake();
    generateRandomFood(playerSnake.position, getTileCounts(context));
  }

  void bulletUpdates() {
    bulletEat();
    handleEnemyGameOver();
  }

  void generateRandomFood(List<int> snakePosition, tilesCount) {
    int index = Random().nextInt(tilesCount);
    while(snakePosition.contains(index)) {
      index = Random().nextInt(tilesCount);
    }
    foodPosition = index;
  }

  void update(Function setStateSnake, Function setStateBullet) {
    gameLoop = Timer.periodic(const Duration(milliseconds: 200),
      (timer) { setStateSnake();}
    );
    bulletLoop = Timer.periodic(const Duration(milliseconds: 80),
      (timer) {  setStateBullet(); }
    );
  }

  void disposeUpdate() {
    gameLoop?.cancel();
    gameLoop = null;
    bulletLoop?.cancel();
    bulletLoop = null;
  }

  void setPositions(pos) {
    playerSnake.changePosition(pos.toList());
  }

  void changeSnakePosition(Direction direction, List<int> snakePosition, context, foodPos) {
    final tilesCount = getTileCounts(context);
    final newPosition = handleMovement(playerSnake,AppConstants.crossAxisCount, tilesCount);
    final newEnemyPos = handleEnemyMovement(tileCounts);
    playerSnake.changePosition(newPosition.toList());
    if(enemySnake!=null) enemySnake?.changePosition(newEnemyPos!.toList());
    final currentPosition = playerSnake.position.toList();
    eat(tilesCount);
    handleGameOver();
    handleEnemyGameOver();
    playerSnake.prevPosition = currentPosition.toList();
    if(enemySnake!=null) enemySnake?.prevPosition = enemySnake!.position.toList();
  }

  List<int> handleMovement(Snake snake,int crossAxisCount, int tilesCount) {
    List<int> newPosition = [];

    int i = 0;
    for(int previousPosition in snake.position) {
      if(i==0) {
        final int result;

        if(previousPosition%crossAxisCount == 0 && snake.direction == Direction.LEFT) {
          result = previousPosition + crossAxisCount-1;
        }
        else if((previousPosition+1) % crossAxisCount == 0 && snake.direction == Direction.RIGHT) {
          result = previousPosition - crossAxisCount+1;
        }
        else if((previousPosition >=0 && previousPosition <= crossAxisCount-1)
            && snake.direction == Direction.UP) {

          result = previousPosition - crossAxisCount + tilesCount;
        }
        else if((previousPosition >= tilesCount-1-crossAxisCount && previousPosition <= tilesCount-1)
            && snake.direction == Direction.DOWN) {
          result = previousPosition%(crossAxisCount);
        }
        else {
          final int factor = snake.getFactor();
          result = factor+previousPosition;
        }
        newPosition.add(result);
      }
      else {
        newPosition.add(snake.position[i-1]);
      }
      i++;
    }

    return newPosition.toList();
  }

  List<int>? handleEnemyMovement(tileCounts) {
    if(enemySnake==null) return null;
    else {
      final Direction newDir;
      if(DateTime.now().difference(lastEnemyChange).inSeconds > 3) {
        newDir= changeDirection(Direction.values[Random().nextInt(
            Direction.values.length)], enemySnake!.direction);
        enemySnake!.changeDirection(newDir);
        lastEnemyChange = DateTime.now();
      }
      return handleMovement(enemySnake!, AppConstants.crossAxisCount, tileCounts);

    }
  }

  void eat(tilesCount, {bool eatEnemy = false}) {
    if(playerSnake.position.contains(foodPosition) || shouldBulletEat || eatEnemy) {
      SystemSound.play(SystemSoundType.click);
      playerSnake.increaseLength();
      if(!eatEnemy) generateRandomFood(playerSnake.position, tilesCount);
      if(shouldBulletEat) shouldBulletEat = false;
    }
  }

  void bulletEat() {
    if(playerSnake.bulletPosition == foodPosition) shouldBulletEat=true;
  }

  bool isGameOver() {
    if(playerSnake.position.toSet().length != playerSnake.position.length) {
      return true;
    }
    if(enemySnake!=null) {
      if(enemySnake!.position.contains(playerSnake.position.first)) {
        return true;
      }
    }
    return false;
  }

  bool isEnemyGameOver() {
    if(enemySnake!=null) {
      if(playerSnake.position.contains(enemySnake?.position.first)) {
        return true;
      }
      if(enemySnake!.position.toSet().length != enemySnake?.position.length) {
        return true;
      }
      if(enemySnake!.position.contains(playerSnake.bulletPosition)) {
        eat(tileCounts,eatEnemy: true);
        return true;
      }
    }

    return false;
  }



  void handleGameOver() {
    if(isGameOver()) {
      disposeUpdate();
    }
  }

  void handleEnemyGameOver() {
    if(isEnemyGameOver()) {
      enemySnake = null;
    }
  }

  Direction changeDirection(Direction newDir, Direction prevDir) {
    if(newDir == Direction.LEFT && prevDir == Direction.RIGHT) return prevDir;
    else if(newDir == Direction.RIGHT && prevDir == Direction.LEFT) return prevDir;
    else if(newDir == Direction.UP && prevDir == Direction.DOWN) return prevDir;
    else if(newDir == Direction.DOWN && prevDir == Direction.UP) return prevDir;

    if(DateTime.now().difference(lastDirectionChange).inMilliseconds > 300) {
      lastDirectionChange = DateTime.now();
      prevDir = newDir;
      return newDir;
    }
    else {
      return prevDir;
    }
  }

  void onPanUpdate(details) {
    // Get the direction of the drag
    Offset delta = details.delta;
    double dx = delta.dx;
    double dy = delta.dy;
    if (dx.abs() > dy.abs()) {
      if (dx > 0) {
        playerSnake.direction = changeDirection(Direction.RIGHT, playerSnake.direction);

      } else {
        playerSnake.direction = changeDirection(Direction.LEFT, playerSnake.direction);

      }
    } else {
      if (dy > 0) {
        playerSnake.direction = changeDirection(Direction.DOWN, playerSnake.direction);

      } else {
        playerSnake.direction = changeDirection(Direction.UP, playerSnake.direction);
      }
    }
  }
}