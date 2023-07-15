import 'package:flutter/material.dart';
import 'package:snake/app/constants/constants.dart';
import 'package:snake/presentation/game/view_model/game_view_model.dart';

class GameMap extends StatelessWidget {
  final GameViewModel vm;
  final Function setState;
  const GameMap({Key? key, required this.vm, required this.setState}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onDoubleTap: () { vm.playerSnake.fireBullet(vm.getTileCounts(context)); },
        onPanUpdate: vm.onPanUpdate,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.crossAxisCount, mainAxisSpacing: AppConstants.crossAxisSpacing,
                crossAxisSpacing: AppConstants.crossAxisSpacing
            ),

            itemCount: vm.getTileCounts(context),
            itemBuilder: (context, index) {
              final opacity = vm.getTileOpacity(index);
              final color = vm.getTileColor(index);
              return AnimatedOpacity(
                opacity: (vm.foodPosition==index) ?  (opacity<0.2) ? 0.2 : opacity : 1,
                duration: const Duration(milliseconds: 100),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: color==Colors.deepOrange? 0: 200),
                  alignment: const Alignment(0,0.5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppConstants.crossAxisCount/7),
                  ),
                  child: (vm.playerSnake.position.first == index) ?
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
        ),
      ),
    );
  }
}
