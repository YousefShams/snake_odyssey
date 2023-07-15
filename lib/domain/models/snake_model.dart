// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:async';
import 'package:snake/app/constants/constants.dart';

import '../../app/enums/snake_direction.dart';

class Snake {

  int length;
  int initialLength;
  List<int> position;
  late List<int> prevPosition;
  Direction direction;
  int? bulletPosition;
  int? bulletFactor;

  Snake({this.length = 4, this.initialLength=4, this.position = const [110,90,70,50],
    this.direction = Direction.DOWN}) {
    prevPosition = position.toList();
  }

  void changePosition(List<int> newPosition) {
    position = newPosition ;
  }

  void changeDirection(Direction newDirection) {
    direction = newDirection;
  }

  void fireBullet(int tileCounts) {
    bulletPosition = position.first;
    bulletFactor = getFactor();

    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      bulletPosition= bulletPosition! + bulletFactor!;

      if((bulletPosition!<0 || bulletPosition! > (tileCounts-1))
        || (bulletFactor==1 && ((bulletPosition!) % AppConstants.crossAxisCount == 0))
        || (bulletFactor==-1 && ((bulletPosition!+1) % AppConstants.crossAxisCount == 0))
      ) {
        timer.cancel();
        bulletPosition = null;
        bulletFactor = null;
      }
    });
  }

  void increaseLength() {
    length = length+1;
    //prevPosition = position.toList();
    position.add(prevPosition.last);
  }

  void resetSnake() {
    length = initialLength;
    position = [110,90,70,50];
    direction = Direction.DOWN;
  }

  int getScore() {
    return (length-initialLength)*10;
  }

  int getFactor() {
    if(direction == Direction.UP) return -20;
    else if(direction == Direction.DOWN) return 20;
    else if(direction == Direction.RIGHT) return 1;
    else return-1;
  }
}