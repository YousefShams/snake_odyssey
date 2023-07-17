// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/app/constants/constants.dart';
import 'package:snake/app/enums/snake_direction.dart';
import 'package:snake/app/services/runtime_cache.dart';
import 'package:snake/domain/models/snake_model.dart';


class GameViewModel {

  Snake playerSnake = Snake();
  //Snake? enemySnake = Snake(direction: Direction.RIGHT, position: [5,4,3,2,1]);
  List<Snake> enemySnakes = [];
  Timer? gameLoop;
  Timer? bulletLoop;
  int foodPosition = 15;
  bool shouldBulletEat = false;
  DateTime lastDirectionChange = DateTime.now();
  DateTime lastDeadEnemy = DateTime.now();
  DateTime lastEnemySpawn = DateTime.now();
  //DateTime? lastEnemyChange;
  bool processingEnemies = false;
  int? tileCounts;

  void update(Function setStateSnake, Function setStateBullet) {
    final millis = AppConstants.maxSlowness - (RuntimeCache.speed*AppConstants.maxSlowness);
    gameLoop = Timer.periodic(Duration(milliseconds: millis.ceil()),
      (timer) {
        spawnEnemy();
        setStateSnake();
      }
    );

    bulletLoop = Timer.periodic(const Duration(milliseconds: 1),
       (timer) {  setStateBullet(); }
    );
  }

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

    if(enemySnakes.isNotEmpty) {
      for(Snake enemySnake in enemySnakes) {
        if(enemySnake.position.contains(index)) return Colors.red;
      }
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
    final opacity = result < 0.80 ? result * 0.5 : result;
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


  void reset(context) {
    disposeUpdate();
    playerSnake.resetSnake();
    enemySnakes.clear();
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

  void disposeUpdate() {
    gameLoop?.cancel();
    gameLoop = null;
    bulletLoop?.cancel();
    bulletLoop = null;
  }


  void changeSnakePosition(Direction direction, List<int> snakePosition, context, foodPos) {
    changePlayerPosition(direction, snakePosition, context, foodPos);
    changeEnemyPosition();
  }


  void changePlayerPosition(Direction direction, List<int> snakePosition, context, foodPos) {
    final tilesCount = getTileCounts(context);
    final newPosition = handleMovement(playerSnake,AppConstants.crossAxisCount, tilesCount);
    playerSnake.changePosition(newPosition.toList());
    final currentPosition = playerSnake.position.toList();
    eat(tilesCount);
    handleGameOver();
    playerSnake.prevPosition = currentPosition.toList();
  }

  void changeEnemyPosition() {
    for(Snake enemySnake in enemySnakes) {
      final newEnemyPos = handleEnemyMovement(enemySnake,tileCounts);
      enemySnake.changePosition(newEnemyPos!.toList());
      //handleEnemyGameOver();
      enemySnake.prevPosition = enemySnake.position.toList();
    }
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

  List<int>? handleEnemyMovement(Snake enemySnake, tileCounts) {
    final Direction newDir;
    if(DateTime.now().difference(enemySnake.lastChange).inSeconds > 3) {
      newDir= changeDirection(Direction.values[Random().nextInt(
          Direction.values.length)], enemySnake.direction);
      enemySnake.changeDirection(newDir);
      enemySnake.changeLastChange(DateTime.now());
    }
    return handleMovement(enemySnake, AppConstants.crossAxisCount, tileCounts);

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
    for(Snake enemySnake in enemySnakes) {
      if(enemySnake.position.contains(playerSnake.bulletPosition)) shouldBulletEat = true;
    }
  }

  bool isGameOver() {
    for(int position in playerSnake.position.sublist(1,playerSnake.position.length)) {
      if(playerSnake.position.first == position) return true;
    }

    for(Snake enemySnake in enemySnakes) {
      if(enemySnake.position.contains(playerSnake.position.first)) {
        return true;
      }
    }

    return false;
  }

  bool isEnemyGameOver(Snake enemySnake) {
    if(playerSnake.position.contains(enemySnake.position.first)) {
      return true;
    }
    if(enemySnake.position.toSet().length != enemySnake.position.length) {
      return true;
    }
    if(enemySnake.position.contains(playerSnake.bulletPosition)) {
      eat(tileCounts,eatEnemy: true);
      return true;
    }
    return false;
  }

  void handleGameOver() {
    if(isGameOver()) {
      disposeUpdate();
    }
  }

  void handleEnemyGameOver() {
    List<int> ids = [];
    for(Snake enemySnake in enemySnakes) {
      if(isEnemyGameOver(enemySnake)) {
        ids.add(enemySnake.id);
        lastDeadEnemy = DateTime.now();
      }
    }
    for(int id in ids) {
      enemySnakes.removeWhere((snake) => snake.id == id);
    }
  }

  Direction changeDirection(Direction newDir, Direction prevDir) {
    if(newDir == Direction.LEFT && prevDir == Direction.RIGHT) return prevDir;
    else if(newDir == Direction.RIGHT && prevDir == Direction.LEFT) return prevDir;
    else if(newDir == Direction.UP && prevDir == Direction.DOWN) return prevDir;
    else if(newDir == Direction.DOWN && prevDir == Direction.UP) return prevDir;

    if(DateTime.now().difference(lastDirectionChange).inMilliseconds > 200) {
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

  void spawnEnemy() {
    if(DateTime.now().difference(lastEnemySpawn).inSeconds > AppConstants.spawnEverySeconds) {
      enemySnakes.add(Snake(direction: Direction.RIGHT, position: [5,4,3,2,1]));
      lastEnemySpawn = DateTime.now();
    }
  }

  void dispose() {
    bulletLoop?.cancel();
    gameLoop?.cancel();
    playerSnake.bulletTimer?.cancel();
  }
}