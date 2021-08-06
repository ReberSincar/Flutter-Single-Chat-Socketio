import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:get/get.dart';

class ConnectScreen extends GetView<ChatController> {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f2f2),
      appBar: AppBar(
        leading: Center(
          child: Text(
            'Chat App',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.start,
          ),
        ),
        leadingWidth: double.infinity,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: controller.connectFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: (value) {
                  controller.user.name = value;
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Can not blank";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.teal,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  hintText: "Name",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  controller.user.surname = value;
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Can not blank";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Surname",
                    labelStyle: TextStyle(color: Colors.teal),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.teal,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    hintText: "Surname"),
              ),
              SizedBox(height: 10),
              Container(
                width: Get.width,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: MaterialButton(
                  child: Text(
                    'Connect',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: controller.connectToSocket,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
