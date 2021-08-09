import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/screens/chat_screen.dart';
import 'package:get/get.dart';

class UsersScreen extends GetView<ChatController> {
  const UsersScreen({Key? key}) : super(key: key);

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
      body: GetBuilder<ChatController>(
        builder: (_) => controller.onlineUsers.isEmpty
            ? Center(
                child: Text(
                  "No online users found",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: controller.onlineUsers.length,
                itemBuilder: (context, index) {
                  User user = controller.onlineUsers[index];
                  return InkWell(
                    onTap: () {
                      Get.to(() => ChatScreen(user: user));
                    },
                    child: Container(
                      width: Get.width,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            child: Text(
                              "${user.name![0]}${user.surname![0]}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "${user.name!} ${user.surname!}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
