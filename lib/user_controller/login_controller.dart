import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isLogin = FirebaseAuth.instance.currentUser != null;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  setLogin({required bool value}) {
    isLogin = value;
    update();
  }

  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;
    update();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(), password: passwordController.text.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
      print('error ---*** --- ${e.code}');
      if (e.code == 'network-request-failed') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == No Internet Connection.');
        errorMessage = "No Internet Connection";
      } else if (e.code == 'too-many-requests') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == Too many attempts please try later');
        errorMessage = "Too many attempts please try later";
      } else if (e.code == 'user-not-found') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == No user found for that email.');
        errorMessage = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == The password is invalid for the given email.');
        errorMessage = "The password is invalid for the given email";
      } else if (e.code == 'invalid-email') {
        debugPrint('ERROR CREATE ON SIGN IN TIME == The email address is not valid.');
        errorMessage = "The email address is not valid";
      } else if (e.code == 'user-disabled') {
        debugPrint(
            'ERROR CREATE ON SIGN IN TIME ==  The user corresponding to the given email has been disabled.');
        errorMessage = "The user corresponding to the given email has been disabled.";
      } else if (e.code == 'invalid-credential') {
        debugPrint('ERROR CREATE ON SIGN IN TIME ==  Invalid credential.');
        errorMessage = "Invalid credential";
      } else {
        debugPrint('ERROR CREATE ON SIGN IN TIME ==  Something went to Wrong.');
        errorMessage = "Something went to Wrong";
      }
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }
}
