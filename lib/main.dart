import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'home/home_screen.dart';
 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
   routes: {
    'home': (context) => const HomeScreen(),
   },
   debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
  ));
}

