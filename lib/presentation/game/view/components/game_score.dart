import 'package:flutter/material.dart';
import 'package:snake/app/constants/constants.dart';
class GameScore extends StatelessWidget {
  final int score;
  final bool gameOver;
  final Function restart;
  const GameScore({Key? key, required this.score, required this.gameOver, required this.restart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    const factor = 36;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.07),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)
        )
      ),
      width: double.infinity,
      height: h * AppConstants.scoreHeightFactor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("SCORE", style: TextStyle(fontSize: h/factor, fontWeight: FontWeight.w700, color: Colors.white),),
          Center(
            child: Visibility(
              visible: gameOver,
              child: IconButton(
                iconSize: 35,
                padding: EdgeInsets.zero,
                alignment: Alignment.topCenter,
                  onPressed: (){restart();},
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.refresh_rounded,color: Colors.white),
                  )),
            ),
          ),
          Text("$score", textAlign: TextAlign.center,
            style: TextStyle(fontSize: h/factor, fontWeight: FontWeight.w700, color: Colors.white),)
        ],
      ),
    );
  }
}
