import 'package:flutter/material.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/screens/connect_screen.dart';
import 'package:flutter_private_chat/screens/users_screen.dart';
import 'package:flutter_private_chat/services/db_services.dart';
import 'package:flutter_private_chat/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  User user = new User();
  List onlineUsers = [];

  GlobalKey<FormState> connectFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> chatFormKey = new GlobalKey<FormState>();
  ScrollController scrollController = new ScrollController();
  SocketService socketService = Get.find();
  DBService dbService = Get.find();
  Uuid uuid = new Uuid();

  TextEditingController messageTextEditingController =
      new TextEditingController();

  connectToSocket() {
    if (connectFormKey.currentState!.validate()) {
      user.id = uuid.v4();
      socketService.connectSocket(user);
    }
  }

  sendMessage(String receiverId) {
    if (messageTextEditingController.text.isNotEmpty) {
      Message messageModel = new Message(
          message: messageTextEditingController.text,
          messageType: 0,
          receiverId: receiverId,
          senderId: user.id,
          createdAt: DateTime.now());
      socketService.sendMessage(messageModel);
      int index = onlineUsers.indexWhere((element) => element.id == receiverId);
      if (index != -1) {
        onlineUsers[index].messages.add(messageModel);
        dbService.addChatUser(onlineUsers[index]);
        update();
      }
      messageTextEditingController.clear();
      scrollToEnd();
    }
  }

  scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 80.0,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
