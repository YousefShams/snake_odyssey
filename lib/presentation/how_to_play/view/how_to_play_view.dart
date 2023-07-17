import 'package:flutter/material.dart';
import 'package:snake/app/application/app_bar_back.dart';
import 'package:snake/app/resources/app_strings.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBarBack(context),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How to play", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
            SizedBox(height: 50),
            Text("Movement", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            SizedBox(height: 20),
            Text(AppStrings.movement, style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),),
            SizedBox(height: 50),
            Text("You can also shoot!", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            SizedBox(height: 20),
            Text(AppStrings.shooting, style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),),
            SizedBox(height: 50),
            Text("Find food", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            SizedBox(height: 20),
            Text(AppStrings.findFood, style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),),

          ],
        ),
      ),
    );
  }
}
