import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/services/socket_service.dart';
import 'package:get/get.dart';

class YourMessageContainer extends GetView<ChatController> {
  const YourMessageContainer({
    Key? key,
    required this.messageIndex,
    required this.userIndex,
  }) : super(key: key);
  final int messageIndex;
  final int userIndex;

  @override
  Widget build(BuildContext context) {
    Message message = controller.onlineUsers[userIndex].messages[messageIndex];
    if (!message.isRead) {
      Get.find<SocketService>().sendReadMessage(message);
      controller.onlineUsers[userIndex].messages[messageIndex].isRead = true;
      Future.delayed(Duration(seconds: 1)).then((value) => controller.update());
    }
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: message.messageType == 0
            ? null
            : () {
                Get.dialog(Dialog(
                  child: Image.memory(message.image!),
                ));
              },
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          padding: EdgeInsets.all(message.messageType == 0 ? 10 : 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message.messageType == 0
                  ? Text(
                      message.message!,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        message.image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
              Text(
                "${message.createdAt!.hour}:${message.createdAt!.minute}",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
