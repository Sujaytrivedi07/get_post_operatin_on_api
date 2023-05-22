import 'dart:convert';

AddEmployee addEmployeeFromJson(String str) => AddEmployee.fromJson(json.decode(str));

String addEmployeeToJson(AddEmployee data) => json.encode(data.toJson());

class AddEmployee {
  String name;
  String email;
  String phone;
  String password;

  AddEmployee({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory AddEmployee.fromJson(Map<String, dynamic> json) => AddEmployee(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
  };
}