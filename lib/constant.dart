import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

CollectionReference reference = FirebaseFirestore.instance.collection('vehicle');

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    {required BuildContext context, required String title}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
    ),
  );
}
