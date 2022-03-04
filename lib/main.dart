import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home/home_screen.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
   routes: {
    'home': (context) => const HomeScreen(),
   },
   debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

