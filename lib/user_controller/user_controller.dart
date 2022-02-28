import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';

class UserController {
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('vehicle');

  Future getUserList() async {
    List<UserData> userlist = [];

    await reference.get().then((value) => value.docs.forEach((element) {
          userlist
              .add(UserData.fromJson(element.data() as Map<String, dynamic>));
        }));
    return userlist;
  }

  Future callDial({required String phoneNumber}) async {
    try {
        await launch("tel://$phoneNumber");
    } catch (e) {
      throw ("Cannot Dial");
    }
  }
  
/*
  Future editUser(String flatno,String ownerName,String contactNo)async{

    await reference.doc().update({
      'FlatNo': flatno,
      "ownerName": ownerName,
      'contactNo': contactNo,

    });
  }

*/



}
