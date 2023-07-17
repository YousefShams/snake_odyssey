import 'package:flutter/material.dart';
import 'package:snake/app/application/app_bar_back.dart';
import 'package:snake/app/services/runtime_cache.dart';


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
            const Text("Settings", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),),
            const SizedBox(height: 70),
            const Text("Speed", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),),
            const SizedBox(height: 50),
            Slider(
                value: RuntimeCache.speed.toDouble(),
                onChanged: (value){ RuntimeCache.updateSpeed(value); setState(() {}); },
                min: 0.1, max: 0.95, label: "${(RuntimeCache.speed.toDouble()*100).round()}%",
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 120,
                child: FilledButton(onPressed: (){Navigator.pop(context);},
                  child: const Text("Done", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
