import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:get/get.dart';

class MyMessageContainer extends StatelessWidget {
  const MyMessageContainer({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
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
          child: message.messageType == 0
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
        ),
      ),
    );
  }
}
