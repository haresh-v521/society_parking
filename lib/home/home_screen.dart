import 'dart:core';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../user_controller/user_controller.dart';
import 'detail.dart';

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

  GlobalKey<FormState> addFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  List<UserData> userAllData = [];
  List<UserData> foundData = [];
  List<UserData> flatList = [];

  bool isabike = false;
  bool isaCar = false;
  bool isEcar = false;
  bool isEbike = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    getUserList();
  }

  fetchData() async {
    dynamic result = await UserController().getUserList();
    setState(() {
      userAllData = result;
      foundData.addAll(userAllData);
    });
    foundData.sort((a, b) => a.flatNo!.compareTo(b.flatNo!));
  }

  Future getUserList() async {
    await reference.get().then((value) {
      value.docChanges.forEach((element) {
        flatList.add(
          UserData.fromJson(
            element.doc.data() as Map<String, dynamic>,
            uid: element.doc.get('FlatNo'),
          ),
        );
      });
    });
    return flatList;
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
              icon: const Icon(Icons.add),
              onPressed: () {
                _addData(context);
              },
            ),
          ],
          backgroundColor: Colors.cyan,
          title: const Text(
            "Shivdhara Residency",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: kIsWeb
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.cyan,
                        ),
                      ),
                      onChanged: (String val) => runFilter(val),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: foundData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ExpansionTile(
                                leading: Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          "asset/images/profile.png"),
                                    ),
                                    Positioned(
                                        left: 38,
                                        top: 30,
                                        child: InkWell(
                                          onTap: () {
                                            editFlatNoController.text =
                                                foundData[index].flatNo!;
                                            editOwnerController.text =
                                                foundData[index].ownerName!;
                                            editContactController.text =
                                                foundData[index].contactNo!;

                                            _editData(context, index);
                                          },
                                          child: Container(
                                              height: 18,
                                              width: 18,
                                              decoration: BoxDecoration(
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Icon(
                                                Icons.edit,
                                                size: 13,
                                                color: Colors.white,
                                              )),
                                        ))
                                  ],
                                ),
                                title: Text(
                                  foundData[index].ownerName ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  foundData[index].flatNo ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Divider(
                                                thickness: 1,
                                              ),
                                              Detail(
                                                ishome: true,
                                                detail:
                                                    foundData[index].flatNo ??
                                                        '',
                                              ),
                                              const Divider(thickness: 1),
                                              Detail(
                                                isperson: true,
                                                iscall: true,
                                                detail: foundData[index]
                                                        .contactNo ??
                                                    '',
                                              ),
                                              const Divider(thickness: 1),
                                              Detail(
                                                iscar: true,
                                                detail:
                                                    foundData[index].car == null
                                                        ? ""
                                                        : foundData[index]
                                                            .car!
                                                            .join('\n\n'),
                                              ),
                                              const Divider(thickness: 1),
                                              Detail(
                                                isbike: true,
                                                detail: foundData[index].bike ==
                                                        null
                                                    ? ""
                                                    : foundData[index]
                                                        .bike!
                                                        .join('\n\n'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )),
                  ],
                ),
              )
            : Column(
                children: [
                  TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.cyan,
                      ),
                    ),
                    onChanged: (String val) => runFilter(val),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: foundData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ExpansionTile(
                              leading: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          "asset/images/profile.png"),
                                    ),
                                    Positioned(
                                        left: 38,
                                        top: 32,
                                        child: InkWell(
                                          onTap: () {
                                            editFlatNoController.text =
                                                foundData[index].flatNo!;
                                            editOwnerController.text =
                                                foundData[index].ownerName!;
                                            editContactController.text =
                                                foundData[index].contactNo!;
                                            _editData(context, index);
                                          },
                                          child: Container(
                                              height: 18,
                                              width: 18,
                                              decoration: BoxDecoration(
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Icon(
                                                Icons.edit,
                                                size: 13,
                                                color: Colors.white,
                                              )),
                                        ))
                                  ],
                                ),
                              ),
                              title: Text(
                                foundData[index].ownerName ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                foundData[index].flatNo ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Divider(
                                              thickness: 1,
                                            ),
                                            Detail(
                                              ishome: true,
                                              detail:
                                                  foundData[index].flatNo ?? '',
                                            ),
                                            const Divider(thickness: 1),
                                            Detail(
                                              isperson: true,
                                              iscall: true,
                                              detail:
                                                  foundData[index].contactNo ??
                                                      '',
                                            ),
                                            const Divider(thickness: 1),
                                            Detail(
                                              iscar: true,
                                              detail:
                                                  foundData[index].car == null
                                                      ? ""
                                                      : foundData[index]
                                                          .car!
                                                          .join('\n\n'),
                                            ),
                                            const Divider(thickness: 1),
                                            Detail(
                                              isbike: true,
                                              detail:
                                                  foundData[index].bike == null
                                                      ? ""
                                                      : foundData[index]
                                                          .bike!
                                                          .join('\n\n'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )),
                ],
              ));
  }

  List<String> bikeNumber = [];
  List<String> carNumber = [];

  _addData(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, StateSetter setState) {
            return AlertDialog(
              title: const Text("Enter User Detail"),
              content: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: addFormKey,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          controller: flatNoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Flat NO",
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.cyan,
                            ),
                          ),
                          validator: (val) {
                            Pattern pattern = r'^[A-Z]{1}\d{1}-\d{0,4}$';
                            RegExp regex = RegExp(pattern.toString());
                            if (val!.isEmpty) {
                              return "Enter Flat No";
                            } else if (!regex.hasMatch(val)) {
                              return 'Enter This Format A1-1234';
                            } else {
                              for (int i = 1; i < flatList.length; i++) {
                                if (flatList[i].flatNo == val) {
                                  return "Already Exists";
                                }
                              }
                            }
                            return null;
                          }),
                      const Divider(),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: ownerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Owner Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.cyan,
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Owner Name";
                          }
                          return null;
                        },
                      ),
                      const Divider(),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: contactController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Contact NO",
                          prefixIcon: Icon(
                            Icons.call,
                            color: Colors.cyan,
                          ),
                        ),
                        validator: (val) {
                          Pattern pattern =
                              r'(^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[456789]\d{9}|(\d[ -]?){10}\d$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter Valid Contact No";
                          } else if (val.length > 16) {
                            return "Enter Valid Contact No";
                          }
                          return null;
                        },
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "After entering the car number press +",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: carController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Enter Car Number",
                          prefixIcon: const Icon(
                            Icons.directions_car,
                            color: Colors.cyan,
                          ),
                          suffixIcon: isaCar
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.cyan,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      carNumber.add(
                                          carController.text.toUpperCase());
                                      carController.clear();
                                      isaCar = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    carController.clear();
                                  },
                                ),
                        ),
                        onChanged: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          setState(() {
                            (regex.hasMatch(val))
                                ? isaCar = true
                                : isaCar = false;
                          });
                        },
                        validator: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter This Format GJ05AB1234";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (carNumber.length <= 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    e.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        carNumber.removeWhere(
                                                            (data) =>
                                                                data.toString() ==
                                                                e.toString());
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: const Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                          size: 15,
                                                        ),
                                                      ))
                                                ],
                                              ))))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "After entering the Bike number press +",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: bikeController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Enter Bike Number",
                          prefixIcon: const Icon(
                            Icons.two_wheeler_outlined,
                            color: Colors.cyan,
                          ),
                          suffixIcon: isabike
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.cyan,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      bikeNumber.add(
                                          bikeController.text.toUpperCase());
                                      bikeController.clear();
                                      isabike = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    bikeController.clear();
                                  },
                                ),
                        ),
                        onChanged: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          setState(() {
                            (regex.hasMatch(val))
                                ? isabike = true
                                : isabike = false;
                          });
                        },
                        validator: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter This Format GJ05AB1234";
                          }
                          return null;
                          /*else if(bikeController.text == bikeNumber){
                          return "Enter Correct number";
                          }*/
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (bikeNumber.length <= 0)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    e.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        bikeNumber.removeWhere(
                                                            (data) =>
                                                                data.toString() ==
                                                                e.toString());
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: const Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                          size: 15,
                                                        ),
                                                      ))
                                                ],
                                              ))))
                                          .toList(),
                                    ),
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
                    if (addFormKey.currentState!.validate()) {
                      showLoading();
                      var createData = {
                        "FlatNo": flatNoController.text.toUpperCase(),
                        "ownerName": ownerController.text,
                        "contactNo": contactController.text,
                        "bike": FieldValue.arrayUnion(bikeNumber),
                        "car": FieldValue.arrayUnion(carNumber),
                      };
                      reference.add(createData).whenComplete(() {
                        hideLoading();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false);
                      });
                    }
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

  _editData(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (
          _,
        ) {
          return StatefulBuilder(builder: (_, StateSetter setState) {
            return AlertDialog(
              title: const Text("Edit Detail"),
              content: SingleChildScrollView(
                child: Form(
                  key: editFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          controller: editFlatNoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Flat NO",
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.cyan,
                            ),
                          ),
                          validator: (val) {
                            Pattern pattern = r'^[A-Z]{1}\d{1}-\d{0,4}$';
                            RegExp regex = RegExp(pattern.toString());
                            if (val!.isEmpty) {
                              return "Enter Flat No";
                            } else if (!regex.hasMatch(val)) {
                              return 'Enter This Format A1-1234';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: editOwnerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Owner Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.cyan,
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Owner Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: editContactController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Contact NO",
                          prefixIcon: Icon(
                            Icons.call,
                            color: Colors.cyan,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          Pattern pattern =
                              r'(^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[456789]\d{9}|(\d[ -]?){10}\d$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter Valid Contact No";
                          } else if (val.length > 16) {
                            return "Enter Valid Contact No";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "After entering the car number press +",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: editCarController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Enter Car Number",
                            prefixIcon: const Icon(
                              Icons.directions_car,
                              color: Colors.cyan,
                            ),
                            suffixIcon: isEcar
                                ? IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      foundData[index].car!.add(
                                          editCarController.text.toUpperCase());
                                      editCarController.clear();
                                      isEcar = false;
                                      setState(() {});
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      editCarController.clear();
                                    },
                                  )),
                        onChanged: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          setState(() {
                            (regex.hasMatch(val))
                                ? isEcar = true
                                : isEcar = false;
                          });
                        },
                        validator: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter This Format GJ05AB1234";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (foundData[index].car?.length ?? 0) <= 0
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Center(
                                    child: Wrap(
                                      runSpacing: 10,
                                      spacing: 10,
                                      direction: Axis.horizontal,
                                      children: foundData[index]
                                          .car!
                                          .map((e) => Container(
                                              height: 25,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    e.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        foundData[index]
                                                            .car!
                                                            .removeWhere((data) =>
                                                                data.toString() ==
                                                                e.toString());
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: const Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                          size: 15,
                                                        ),
                                                      ))
                                                ],
                                              ))))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "After entering the Bike number press +",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: editBikeController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Enter Bike Number",
                            prefixIcon: const Icon(
                              Icons.two_wheeler_outlined,
                              color: Colors.cyan,
                            ),
                            suffixIcon: isEbike
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.cyan,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        foundData[index].bike!.add(
                                            editBikeController.text
                                                .toUpperCase());
                                        editBikeController.clear();
                                        isEbike = false;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      editBikeController.clear();
                                    },
                                  )),
                        onChanged: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          setState(() {
                            (regex.hasMatch(val))
                                ? isEbike = true
                                : isEbike = false;
                          });
                        },
                        validator: (val) {
                          Pattern pattern =
                              r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{3,4}$)';

                          RegExp regex = RegExp(pattern.toString());
                          if ((!regex.hasMatch(val!)) && val.isNotEmpty) {
                            return "Enter This Format GJ05AB1234";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (foundData[index].bike?.length ?? 0) <= 0
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Center(
                                    child: Wrap(
                                      runSpacing: 10,
                                      spacing: 10,
                                      direction: Axis.horizontal,
                                      children: foundData[index]
                                          .bike!
                                          .map((e) => Container(
                                              height: 25,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    e.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        foundData[index]
                                                            .bike!
                                                            .removeWhere((data) =>
                                                                data.toString() ==
                                                                e.toString());
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: const Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                          size: 15,
                                                        ),
                                                      ))
                                                ],
                                              ))))
                                          .toList(),
                                    ),
                                  ),
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
                    if (editFormKey.currentState!.validate()) {
                      showLoading();
                      final firestoreInstance = FirebaseFirestore.instance;

                      firestoreInstance
                          .collection("vehicle")
                          .doc(foundData[index].uid)
                          .update({
                        'car': FieldValue.delete(),
                        'bike': FieldValue.delete()
                      });
                      var createData = {
                        "FlatNo": editFlatNoController.text.toUpperCase(),
                        "ownerName": editOwnerController.text,
                        "contactNo": editContactController.text,
                        "car": foundData[index].car == null
                            ? null
                            : FieldValue.arrayUnion(foundData[index].car!),
                        "bike": foundData[index].bike == null
                            ? null
                            : FieldValue.arrayUnion(foundData[index].bike!),
                      };

                      firestoreInstance
                          .collection("vehicle")
                          .doc(foundData[index].uid)
                          .update(createData)
                          .whenComplete(() {
                        hideLoading();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false);
                      });
                    }

                    // setState((){});
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

  showLoading() {
    return Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierColor: Colors.transparent,
        barrierDismissible: false);
  }

  hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
