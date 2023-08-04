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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.howTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
            const SizedBox(height: 50),
            Text(AppStrings.movementTitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 20),
            Text(AppStrings.movement, style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),),
            const SizedBox(height: 50),
            Text(AppStrings.shootTitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 20),
            Text(AppStrings.shooting, style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),),
            const SizedBox(height: 50),
            Text(AppStrings.foodTitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 20),
            Text(AppStrings.findFood, style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),),

          ],
        ),
      ),
    );
  }
}
