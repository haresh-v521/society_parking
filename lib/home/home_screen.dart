import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/user_model.dart';
import '../user_controller/user_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('vehicle');

  TextEditingController flatNoController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController bikeController = TextEditingController();
  TextEditingController carController = TextEditingController();

  TextEditingController editFlatNoController = TextEditingController();
  TextEditingController editOwnerController = TextEditingController();
  TextEditingController editContactController = TextEditingController();
  TextEditingController editBikeController = TextEditingController();
  TextEditingController editCarController = TextEditingController();

  TextEditingController textEditingController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<UserData> userAllData = [];
  List<UserData> foundData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    dynamic result = await UserController().getUserList();
    setState(() {
      userAllData = result;
      foundData.addAll(userAllData);
    });
  }

  void runFilter(String enterVal) {
    if (enterVal.isEmpty) {
      foundData = userAllData;
    } else {
      foundData = userAllData
          .where((user) =>
              user.ownerName!.toLowerCase().contains(enterVal.toLowerCase()) ||
              user.contactNo!.toLowerCase().contains(enterVal.toLowerCase()) ||
              user.car
                  .toString()
                  .toLowerCase()
                  .contains(enterVal.toLowerCase()) ||
              user.bike
                  .toString()
                  .toLowerCase()
                  .contains(enterVal.toLowerCase()) ||
              user.flatNo!.toLowerCase().contains(enterVal.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showDialog(context);
              },
            ),
          ],
          backgroundColor: Colors.cyan,
          title: Text(
            "Society Parking",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: Column(
                children: [
                  TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.cyan,
                      ),
                    ),
                    onChanged: (String val) => runFilter(val),
                  ),
                  Divider(thickness: 2),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Container(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: foundData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ExpansionTile(
                                backgroundColor: Colors.black12,
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage("asset/images/profile.png"),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      foundData[index].ownerName ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      color: Colors.blue,
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editData(context);
                                      },
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  foundData[index].flatNo ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan),
                                ),
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Detail(
                                                  ishome: true,
                                                  text: '',
                                                  detail:
                                                      foundData[index].flatNo ??
                                                          '',
                                                ),
                                                Divider(thickness: 1),
                                                Detail(
                                                  isperson: true,
                                                  iscall: true,
                                                  text: '',
                                                  detail: foundData[index]
                                                          .contactNo ??
                                                      '',
                                                ),
                                                Divider(thickness: 1),
                                                Detail(
                                                  text: '',
                                                  iscar: true,
                                                  detail: foundData[index]
                                                      .car!
                                                      .join(',\n\n '),
                                                ),
                                                Divider(thickness: 1),
                                                Detail(
                                                  isbike: true,
                                                  text: '',
                                                  detail: foundData[index]
                                                      .bike!
                                                      .join(',\n\n'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  )),
                ],
              ),
            )));
  }

  List<String> bikeNumber = [];
  List<String> carNumber = [];

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (
          _,
        ) {
          return StatefulBuilder(builder: (_, StateSetter setState) {
            return AlertDialog(
              title: Text("Enter User Detail"),
              content: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        controller: flatNoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Flat NO",
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      Divider(),
                      TextFormField(
                        controller: ownerController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Owner Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      Divider(),
                      TextFormField(
                        controller: contactController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Contact NO",
                          prefixIcon: Icon(
                            Icons.call,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      Divider(),
                      TextFormField(
                        controller: carController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "GJ05AB1234",
                          prefixIcon: Icon(
                            Icons.directions_car,
                            color: Colors.cyan,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.cyan,
                            ),
                            onPressed: () {
                              setState(() {
                                carNumber.add(carController.text.toUpperCase());
                                carController.clear();
                              });
                            },
                          ),
                        ),
                        validator: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter Valid Number ";
                          }
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              direction: Axis.horizontal,
                              children: carNumber
                                  .map((e) => Container(
                                      height: 25,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            e.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                carNumber.removeWhere((data) =>
                                                    data.toString() ==
                                                    e.toString());
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                                size: 15,
                                              ))
                                        ],
                                      ))))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: bikeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "GJ05AB1212  ",
                          prefixIcon: Icon(
                            Icons.two_wheeler_outlined,
                            color: Colors.cyan,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.cyan,
                            ),
                            onPressed: () {
                              setState(() {
                                bikeNumber
                                    .add(bikeController.text.toUpperCase());
                                bikeController.clear();
                              });
                            },
                          ),
                        ),
                        validator: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter Valid Number ";
                          }
                          /*else if(bikeController.text == bikeNumber){
                          return "Enter Correct number";
                          }*/
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              direction: Axis.horizontal,
                              children: bikeNumber
                                  .map((e) => Container(
                                      height: 25,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            e.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                bikeNumber.removeWhere((data) =>
                                                    data.toString() ==
                                                    e.toString());
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                                size: 15,
                                              ))
                                        ],
                                      ))))
                                  .toList(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancle",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.cyan)),
                  onPressed: () {
                    var createData = {
                      "FlatNo": flatNoController.text.toUpperCase(),
                      "ownerName": ownerController.text,
                      "contactNo": contactController.text,
                      "bike": FieldValue.arrayUnion(bikeNumber),
                      "car": FieldValue.arrayUnion(carNumber),
                    };
                    reference
                        .add(createData)
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.cyan),
                  ),
                ),
              ],
            );
          });
        });
  }

  _editData(BuildContext context) {
    showDialog(
        context: context,
        builder: (
          _,
        ) {
          return StatefulBuilder(builder: (_, StateSetter setState) {
            return AlertDialog(
              title: Text("Enter Edit Detail"),
              content: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        controller: editFlatNoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Flat NO",
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: editOwnerController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Owner Name",
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancle",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.cyan)),
                  onPressed: () async {
                    final CollectionReference reference =
                    FirebaseFirestore.instance.collection('vehicle');

                    QuerySnapshot querysnapshot = await reference.get();

                    var createData = {
                      "FlatNo": editFlatNoController.text.toUpperCase(),
                      "ownerName": editOwnerController.text,
                      //"contactNo": contactController.text,
                      //"bike": FieldValue.arrayUnion(bikeNumber),
                      //"car": FieldValue.arrayUnion(carNumber),
                    };
                    querysnapshot.docs[1].reference.update(createData).whenComplete(() => Navigator.of(context).pop());


                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.cyan),
                  ),
                ),
              ],
            );
          });
        });
  }
}

class Detail extends StatelessWidget {
  const Detail(
      {Key? key,
      required this.text,
      required this.detail,
      this.iscall = false,
      this.iscar = false,
      this.isbike = false,
      this.isperson = false,
      this.ishome = false});

  final String text;
  final String detail;
  final bool iscall;
  final bool iscar;
  final bool isbike;
  final bool isperson;
  final bool ishome;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (ishome)
            Icon(
              Icons.home,
              color: Colors.black54,
            ),
          if (iscar)
            Icon(
              Icons.directions_car,
              color: Colors.black54,
            ),
          if (isbike)
            Icon(
              Icons.two_wheeler_outlined,
              color: Colors.black54,
            ),
          if (isperson)
            Icon(
              Icons.person,
              color: Colors.black54,
            ),
          Container(
              width: MediaQuery.of(context).size.width / 15,
              child: Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Text(
            ":  ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            child: Expanded(child: Text(detail)),
          ),
          if (iscall)
            IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.cyan,
                ),
                onPressed: () {
                  UserController().callDial(phoneNumber: detail);
                }),
        ],
      ),
    );
  }
}
