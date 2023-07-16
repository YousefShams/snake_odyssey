// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:async';
import 'package:snake/app/constants/constants.dart';

import '../../app/enums/snake_direction.dart';

class Snake {

  int initialLength;
  List<int> position;
  late List<int> prevPosition;
  Direction direction;
  int? bulletPosition;
  int? bulletFactor;
  late DateTime lastChange;
  Timer? bulletTimer;

  Snake({this.initialLength=4, this.position = const [110,90,70,50],
    this.direction = Direction.DOWN}) {
    prevPosition = position.toList();
    lastChange = DateTime.now();
  }

  void changePosition(List<int> newPosition) {
    position = newPosition ;
  }

  void changeDirection(Direction newDirection) {
    direction = newDirection;
  }

  void changeLastChange(DateTime time) {
    lastChange = time;
  }

  void fireBullet(int tileCounts) {
    if(bulletPosition==null) {
      bulletPosition = position.first;
      bulletFactor = getFactor();

      bulletTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        if(bulletPosition!=null) {
          bulletPosition= bulletPosition! + bulletFactor!;
          if((bulletPosition!<0 || bulletPosition! > (tileCounts-1)) ||
              (bulletFactor==1 && ((bulletPosition!) % AppConstants.crossAxisCount == 0)) ||
              (bulletFactor==-1 && ((bulletPosition!+1) % AppConstants.crossAxisCount == 0)))
          {
            bulletPosition = null;
            bulletFactor = null;
            timer.cancel();
            bulletTimer = null;
          }
        }
        else {
          timer.cancel();
        }
      });
    }
  }

  void increaseLength() {
    position.add(prevPosition.last);
  }

  void resetSnake() {
    position = [110,90,70,50];
    direction = Direction.DOWN;
  }

  int getScore() {
    return (position.length-initialLength)*10;
  }

  int getFactor() {
    if(direction == Direction.UP) return -1*AppConstants.crossAxisCount;
    else if(direction == Direction.DOWN) return AppConstants.crossAxisCount;
    else if(direction == Direction.RIGHT) return 1;
    else return-1;
  }

}