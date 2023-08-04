import 'package:flutter/material.dart';
import 'package:snake/app/application/app_bar_back.dart';
import 'package:snake/app/resources/app_strings.dart';
import 'package:snake/app/services/runtime_cache.dart';
import 'package:snake/app/transition/page_transition.dart';
import 'package:snake/presentation/home/view/home_view.dart';
import 'package:snake/presentation/settins/view/components/settings_language_button.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
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
            Text(AppStrings.settingsTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
            const SizedBox(height: 70),
            Text(AppStrings.speedTitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 20),
            Slider(
                value: RuntimeCache.speed.toDouble(),
                onChanged: (value){ RuntimeCache.updateSpeed(value); setState(() {}); },
                min: 0.1, max: 0.95, label: "${(RuntimeCache.speed.toDouble()*100).round()}%",
            ),
            const SizedBox(height: 70),
            Text(AppStrings.languageTitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 20),
            SettingsLanguageButton(update:  () { setState((){}); }  ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 120,
                child: FilledButton(onPressed: (){
                  Navigator.pushAndRemoveUntil(context,
                      PageTransition(const HomeScreen()), (route) => false);
                },
                  child: Text(AppStrings.doneButton, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
