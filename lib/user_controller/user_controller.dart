import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';

class UserController {
  CollectionReference reference =
      FirebaseFirestore.instance.collection('vehicle');
  List<UserData> userlist = [];

  Future getUserList() async {
    await reference.get().then((value) {
      value.docChanges.forEach((element) {
        print(element.doc.id);

        userlist
            .add(UserData.fromJson(element.doc.data() as Map<String, dynamic>,uid: element.doc.id),);
      });
    });
    return userlist;
  }

  Future callDial({required String phoneNumber}) async {
    try {
      await launch("tel://$phoneNumber");
    } catch (e) {
      throw ("Cannot Dial");
    }
  }


}
