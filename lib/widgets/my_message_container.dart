import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:get/get.dart';

class MyMessageContainer extends GetView<ChatController> {
  const MyMessageContainer({
    Key? key,
    required this.messageIndex,
    required this.userIndex,
  }) : super(key: key);
  final int messageIndex;
  final int userIndex;

  @override
  Widget build(BuildContext context) {
    Message message = controller.onlineUsers[userIndex].messages[messageIndex];
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: message.messageType == 0
            ? null
            : () {
                Get.dialog(Dialog(
                  child: Image.memory(message.image!),
                ));
              },
        child: Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          padding: EdgeInsets.all(message.messageType == 0 ? 10 : 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.teal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              message.messageType == 0
                  ? Text(
                      message.message!,
                      style: TextStyle(
                        color: Colors.white,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${message.createdAt!.hour}:${message.createdAt!.minute}",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12,
                    ),
                  ),
                  Visibility(
                    visible: message.isSend || message.isRead,
                    child: Row(
                      children: [
                        SizedBox(width: 2.5),
                        Align(
                          widthFactor: 0.5,
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Align(
                          widthFactor: 0.01,
                          child: Visibility(
                            visible: message.isRead,
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
