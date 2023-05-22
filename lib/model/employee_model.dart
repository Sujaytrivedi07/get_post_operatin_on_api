// To parse this JSON data, do
//
//     final employeeLis = employeeLisFromJson(jsonString);

import 'dart:convert';

EmployeeLis employeeLisFromJson(String str) => EmployeeLis.fromJson(json.decode(str));

String employeeLisToJson(EmployeeLis data) => json.encode(data.toJson());

class EmployeeLis {
  int successCode;
  String successMessage;
  List<ListElement> list;

  EmployeeLis({
    required this.successCode,
    required this.successMessage,
    required this.list,
  });

  factory EmployeeLis.fromJson(Map<String, dynamic> json) => EmployeeLis(
    successCode: json["successCode"],
    successMessage: json["successMessage"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "successCode": successCode,
    "successMessage": successMessage,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListElement {
  String id;
  String name;
  String email;
  int? phone;
  String password;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ListElement({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.password,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
