import 'package:flutter/material.dart';
import 'package:snake/app/constants/constants.dart';
import 'package:snake/app/resources/app_strings.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
          Text(AppStrings.score, style: TextStyle(fontSize: h/factor, fontWeight: FontWeight.w700, color: Colors.white),),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 30),
            child: Center(
              child: Visibility(
                visible: gameOver,
                child: IconButton(
                  iconSize: 45,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topCenter,
                    onPressed: (){restart();},
                    icon: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.refresh_rounded,color: Colors.white),
                    )),
              ),
            ),
          ),
          Text("$score", textAlign: TextAlign.center,
            style: TextStyle(fontSize: h/factor, fontWeight: FontWeight.w700, color: Colors.white),)
        ],
      ),
    );
  }
}
