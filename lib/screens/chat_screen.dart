import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/widgets/your_message_container.dart';
import 'package:flutter_private_chat/widgets/my_message_container.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({Key? key, required this.userIndex}) : super(key: key);
  final int userIndex;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Color(0xFFf2f2f2),
          appBar: buildAppBar(),
          body: Column(
            children: [
              buildMessages(),
              buildMessageFieldAndSendButton(),
            ],
          ),
        );
      },
    );
  }

  Widget buildMessages() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 15),
        reverse: true,
        itemCount: controller.onlineUsers[userIndex].messages!.length,
        itemBuilder: (context, index) {
          User user = controller.onlineUsers[userIndex];
          Message message = user.messages![index];
          return message.senderId == controller.user.id
              ? MyMessageContainer(messageIndex: index, userIndex: userIndex)
              : YourMessageContainer(messageIndex: index, userIndex: userIndex);
        },
      ),
    );
  }

  Container buildMessageFieldAndSendButton() {
    User user = controller.onlineUsers[userIndex];
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.transparent,
      child: Padding(
        padding: GetPlatform.isIOS
            ? EdgeInsets.only(bottom: 20)
            : EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                child: TextFormField(
                  controller: controller.messageTextEditingController,
                  decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.all(10.0),
                      fillColor: Colors.white,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: user.isOnline!
                                ? () {
                                    controller.sendImageMessage(user.id!, true);
                                  }
                                : null,
                            child: Icon(Icons.image,
                                color: user.isOnline!
                                    ? Colors.teal
                                    : Colors.grey.shade500),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: user.isOnline!
                                ? () {
                                    controller.sendImageMessage(
                                        user.id!, false);
                                  }
                                : null,
                            child: Icon(Icons.camera,
                                color: user.isOnline!
                                    ? Colors.teal
                                    : Colors.grey.shade500),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Your message"),
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 50,
              child: FloatingActionButton(
                onPressed: user.isOnline!
                    ? () {
                        controller.sendMessage(user.id!);
                      }
                    : null,
                backgroundColor:
                    user.isOnline! ? Colors.teal : Colors.grey.shade500,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    User user = controller.onlineUsers[userIndex];
    return AppBar(
      leadingWidth: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => Get.back(),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios),
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    "${user.name![0]}${user.surname![0]}",
                    style: TextStyle(color: Colors.teal, fontSize: 16),
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
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
              Text(
                user.isTyping
                    ? "Typing..."
                    : user.isOnline!
                        ? "Online"
                        : "Offline",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: user.isOnline! ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.teal,
    );
  }
}
