import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.ownerName,
    this.flatNo,
    this.car,
    this.contactNo,
    this.bike,
  });

  String? ownerName;
  String? flatNo;
  List<String>? car;
  List<String>? bike;
  String? contactNo;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    ownerName: json["ownerName"],
    flatNo: json["FlatNo"],
    car: List<String>.from(json["car"].map((x) => x)),
    bike: List<String>.from(json["bike"].map((x) => x)),
    contactNo: json["contactNo"],
  );

  Map<String, dynamic> toJson() => {
    "ownerName": ownerName,
    "FlatNo": flatNo,
    "car": List<dynamic>.from(car!.map((x) => x)),
    "bike": List<dynamic>.from(bike!.map((x) => x)),
    "contactNo": contactNo,
  };
}
