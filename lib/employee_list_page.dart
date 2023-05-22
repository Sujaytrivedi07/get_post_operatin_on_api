import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_employee_list_crud/model/add_employee_model.dart';
import 'package:provider/provider.dart';

import 'app_provider.dart';
import 'model/employee_model.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  AppProvider? appProvider;
  EmployeeLis? employeeLis;
  AddEmployee? addEmployee;
  TextEditingController emppasswordcontroller = TextEditingController();
  TextEditingController empnamecontroller = TextEditingController();
  TextEditingController empemailcontroller = TextEditingController();
  TextEditingController empphonecontroller = TextEditingController();

  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    callme();
    // print(">>>>>>>>>>>>>${employeeLis?.list[0].name}");
    // TODO: implement initState
    super.initState();
  }

  callme() async {
    getEmployee().then((value) {
      employeeLis = value;
      appProvider?.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    appProvider = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee List"),
      ),
      body: employeeLis == null
          ? Center(child: CircularProgressIndicator())
          : Emplist(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                height: 400,
                color: Colors.lime,
                child: Column(children: [
                  Text("Enter a Employee Details"),
                  TextField(
                    controller: empnamecontroller,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter Your Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  TextField(
                    controller: empemailcontroller,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter Your Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  TextField(
                    controller: empphonecontroller,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter Your Phone_Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  TextField(
                    controller: emppasswordcontroller,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter Your Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            if (empemailcontroller.text.length >= 1 &&
                                empnamecontroller.text.length >= 1 &&
                                empphonecontroller.text.length >= 1 &&
                                emppasswordcontroller.text.length >= 1) {
                              postEmployee(AddEmployee(
                                      name: empnamecontroller.text,
                                      email: empemailcontroller.text,
                                      phone: empphonecontroller.text,
                                      password: emppasswordcontroller.text))
                                  .then((value) {
                                print("post api posted");
                                empemailcontroller.clear();
                                empnamecontroller.clear();
                                empphonecontroller.clear();
                                emppasswordcontroller.clear();
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                print(error.toString());
                              });
                              appProvider?.refresh();
                            } else {
                              print("Enter a Valid Inputs");
                            }
                          },
                          child: Text("Add")),
                    ],
                  )
                ]),
              ),
            ),
          );
          // postEmployee(AddEmployee(
          //         name: "krvijay",
          //         email: "sujaytrivedi9999@gmail.com",
          //         phone: "78686868",
          //         password: "cijdbicb"))
          //     .then((value) {
          //   print("post api posted");
          // }).onError((error, stackTrace) {
          //   print(error.toString());
          // });
          appProvider?.refresh();
        },
        child: Text("Add"),
      ),
    );
  }

  Widget Emplist() {
    return ListView.builder(
      itemCount: employeeLis?.list.length,
      itemBuilder: (context, index) => SizedBox(
        height: 100,
        child: Card(
          color: Colors.greenAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.person),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employeeLis?.list[index].name ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(employeeLis?.list[index].email ?? ""),
                    Text(employeeLis?.list[index].phone.toString() ?? ""),
                  ],
                ),
              ),
              employeeLis!.list[index].status
                  ? Icon(
                      Icons.circle,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.circle,
                      color: Colors.red,
                    ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.update),
                color: Colors.black,
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.delete),
              //   color: Colors.red,
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> getEmployee() async {
    String baseurl = "https://openuserapi.onrender.com/admin/users";
    Dio dio = Dio();
    dynamic response = await dio.get(baseurl);
    print(response);
    var res = response.data;
    if (response.statusCode == 200) {
      print("api hitted");
    } else {
      print("api not hitted");
    }
    return EmployeeLis.fromJson(res);
  }

  Future<void> postEmployee(AddEmployee addEmployee) async {
    String baseurl = "https://openuserapi.onrender.com/admin/create-user";
    Dio dio = Dio();
    dynamic postemp = await dio
        .post(baseurl,
            data: addEmployee.toJson(),
            options: Options(contentType: 'application/json'))
        .then((value) async {
      var responce = await jsonDecode(value.toString());
    }).onError((error, stackTrace) {
      error.toString();
    });
  }
}
