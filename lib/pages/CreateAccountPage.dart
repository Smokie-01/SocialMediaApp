import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media/widgets/HeaderWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  //// GlobalKey used to uniquely identify the Scaffold widget
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // GlobalKey used to uniquely identify the Form widget
  final _formKey = GlobalKey<FormState>();
  String? userName;

  submitUserName() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome" + userName.toString()),
        ),
      );
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, userName);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(context, title: "Settings", disableBackButton: true),
      body: ListView(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 25),
                child: Center(
                  child: Text(
                    "Set up Username ",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      validator: ((value) {
                        if (value!.trim().length < 5) {
                          return "User name is very short";
                        } else if (value.trim().length > 15) {
                          return "User name is very Long ";
                        }
                        return null;
                      }),
                      onSaved: (val) {
                        userName = val;
                      },
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          labelText: 'Enter Username ',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          hintText: "must be atleast 5 characters "),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  submitUserName();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
