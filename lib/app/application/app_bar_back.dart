
import 'package:flutter/material.dart';

AppBar appBarBack(context) {
  return AppBar(
    backgroundColor: Colors.black,
    leading: IconButton(onPressed: (){ Navigator.pop(context); },
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,)),
  );
}