import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/widgets/your_message_container.dart';
import 'package:flutter_private_chat/widgets/my_message_container.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f2f2),
      appBar: buildAppBar(),
      bottomSheet: buildMessageFieldAndSendButton(),
      body: buildMessages(),
    );
  }

  buildMessages() {
    return GetBuilder<ChatController>(
      builder: (_) {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 80),
          controller: controller.scrollController,
          itemCount: user.messages.length,
          itemBuilder: (context, index) {
            Message message = user.messages[index];
            return message.senderId == controller.user.id
                ? MyMessageContainer(message: message)
                : YourMessageContainer(message: message);
          },
        );
      },
    );
  }

  Container buildMessageFieldAndSendButton() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(10),
      color: Color(0xFFf2f2f2),
      child: Padding(
        padding:
            GetPlatform.isIOS ? EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Your message"),
                ),
              ),
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () {
                controller.sendMessage(user.id!);
              },
              backgroundColor: Colors.teal,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leadingWidth: 0.0,
      automaticallyImplyLeading: false,
      // leading: InkWell(
      //   onTap: () => Get.back(),
      //   child: Padding(
      //     padding: EdgeInsets.only(left: 10.0),
      //     child: Icon(Icons.arrow_back_ios),
      //   ),
      // ),
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => Get.back(),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios),
                CircleAvatar(
                  radius: 25,
                  child: Text(
                    "${user.name![0]}${user.surname![0]}",
                    style: TextStyle(color: Colors.teal, fontSize: 20),
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(
            "${user.name!} ${user.surname!}",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      backgroundColor: Colors.teal,
    );
  }
}
