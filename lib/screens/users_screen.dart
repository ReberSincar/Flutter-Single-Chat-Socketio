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
                  "No users found",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.onlineUsers.length,
                itemBuilder: (context, index) {
                  User user = controller.onlineUsers[index];
                  int unReadMessageCount = controller
                      .onlineUsers[index].messages
                      .where((e) =>
                          e.isRead == false &&
                          e.receiverId == controller.user.id)
                      .length;
                  return InkWell(
                    onTap: () {
                      controller.chattingUserId = user.id;
                      Get.to(() => ChatScreen(userIndex: index));
                    },
                    child: Container(
                      width: Get.width,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 27.5,
                            child: Text(
                              "${user.name![0]}${user.surname![0]}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.name!} ${user.surname!}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 7.5,
                                    height: 7.5,
                                    decoration: BoxDecoration(
                                      color: user.isOnline!
                                          ? Colors.green
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    user.isOnline! ? "Online" : "Offline",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Visibility(
                            visible: unReadMessageCount > 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  unReadMessageCount.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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
