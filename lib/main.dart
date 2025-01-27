import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCdS69M0pNQBMPDQPXW08LNJqhunWOBO10",
          authDomain: "society-parking.firebaseapp.com",
          projectId: "society-parking",
          storageBucket: "society-parking.appspot.com",
          messagingSenderId: "372126564712",
          appId: "1:372126564712:web:fb1fc9ee36b15649ea96dd",
          measurementId: "G-675JKPM6VN"));
  runApp(GetMaterialApp(
    routes: {
      'home': (context) => const HomeScreen(),
    },
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
  ));
}
