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
    this.uid
  });

  String? ownerName;
  String? flatNo;
  List<String>? car=[];
  List<String>? bike=[];
  String? contactNo;
  String? uid;

  factory UserData.fromJson(Map<String, dynamic> json,{String? uid}) => UserData(
    ownerName:  json["ownerName"] == null ? null : json["ownerName"],
    flatNo: json["FlatNo"] == null ? null : json["FlatNo"],
    car:json["car"]==null?[]: List<String>.from(json["car"].map((x) => x)),
    bike:json["bike"]==null?[]:  List<String>.from(json["bike"].map((x) => x)),
    contactNo:  json["contactNo"] == null ? null : json["contactNo"],
    uid: uid
  );

  Map<String, dynamic> toJson() => {
    "ownerName": ownerName==null?null:ownerName,
    "FlatNo":  flatNo == null ? null : flatNo,
    "car": car==null?[]:List<dynamic>.from(car!.map((x) => x)),
    "bike":bike==null?[]: List<dynamic>.from(bike!.map((x) => x)),
    "contactNo": contactNo == null ? null : contactNo,
    "uid":uid
  };
}
// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);
