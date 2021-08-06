import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/screens/connect_screen.dart';
import 'package:flutter_private_chat/screens/users_screen.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class SocketService extends GetxService {
  Uuid uuid = Uuid();
  IO.Socket? socket;
  // String? userId;
  void connectSocket(User user) {
    // userId = uuid.v4();
    socket = IO.io(
        "Your server address",
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'user': json.encode(user.toJson())}) // optional
            .build());
    socket!.onConnect((_) {
      print('connected');
      Get.off(UsersScreen());
    });
    socket!.onDisconnect((_) {
      print('disconnect');
      Get.offAll(ConnectScreen());
    });

    socket!.on('newMessage', (data) {
      print(data);
      ChatController chatController = Get.find();
      Message message = Message.fromJson(data);
      int index = chatController.onlineUsers.indexWhere((user) {
        if (user.id == message.senderId || user.id == message.receiverId) {
          return true;
        }
        return false;
      });

      if (index != -1) {
        chatController.onlineUsers[index].messages.add(message);
        chatController.update();
        chatController.scrollToEnd();
      }
    });

    socket!.on('users', (users) {
      print(users);
      ChatController chatController = Get.find();
      chatController.onlineUsers.clear();
      for (var userJson in users) {
        User user = User.fromJson(userJson);
        if (user.id != chatController.user.id) {
          chatController.onlineUsers.add(user);
        }
      }
      chatController.update();
    });
  }

  void sendMessage(Message message) {
    socket!.emit(
      'newMessage',
      message.toJson(),
    );
  }
}
