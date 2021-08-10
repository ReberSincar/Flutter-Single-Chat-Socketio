import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/screens/connect_screen.dart';
import 'package:flutter_private_chat/screens/users_screen.dart';
import 'package:flutter_private_chat/services/db_services.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:convert';

class SocketService extends GetxService {
  DBService dbService = Get.find();
  IO.Socket? socket;

  void connectSocket(User user) {
    socket = IO.io(
        'Your server address', // Change here
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'user': json.encode(user.toJson())}) // optional
            .build());
    socket!.onConnect((_) {
      print('connected');
      socket!.emit("connectUser", jsonEncode(user.toJsonForConnect()));
      ChatController chatController = Get.find();
      chatController.user = user;
      dbService.addUser(user);
      Get.off(UsersScreen());
    });

    socket!.onDisconnect((_) {
      print('disconnect');
      Get.offAll(ConnectScreen());
    });

    socket!.on("messageReceived", (data) {
      print(data);
      ChatController chatController = Get.find();
      int userIndex = chatController.onlineUsers
          .indexWhere((element) => element.id == data["receiver_id"]);
      if (userIndex != -1) {
        int messageIndex = chatController.onlineUsers[userIndex].messages
            .indexWhere((element) => element.id == data["message_id"]);
        if (messageIndex != -1) {
          chatController.onlineUsers[userIndex].messages[messageIndex].isSend =
              true;
          chatController.update();
        }
      }
    });

    socket!.on("messageRead", (data) {
      print(data);
      ChatController chatController = Get.find();
      int userIndex = chatController.onlineUsers
          .indexWhere((element) => element.id == data["receiver_id"]);
      if (userIndex != -1) {
        int messageIndex = chatController.onlineUsers[userIndex].messages
            .indexWhere((element) => element.id == data["message_id"]);
        if (messageIndex != -1) {
          chatController.onlineUsers[userIndex].messages[messageIndex].isRead =
              true;
          chatController.update();
        }
      }
    });

    socket!.on('newMessage', (data) {
      print(data);
      ChatController chatController = Get.find();
      Message message = Message.fromJson(data);
      socket!.emit("messageReceived", {
        "message_id": message.id,
        "sender_id": message.senderId,
        "receiver_id": message.receiverId,
      });
      int index = chatController.onlineUsers.indexWhere((user) {
        if (user.id == message.senderId || user.id == message.receiverId) {
          return true;
        }
        return false;
      });

      if (index != -1) {
        chatController.onlineUsers[index].messages.insert(0, message);
        dbService.addChatUserMessages(chatController.onlineUsers[index]);
        chatController.update();
      }
    });

    socket!.on('users', (users) {
      print(users);
      ChatController chatController = Get.find();
      chatController.onlineUsers.clear();
      for (var userJson in users) {
        User user = User.fromJson(userJson);
        if (user.id != chatController.user.id) {
          var messages = dbService.getChatUserMessages(user.id!);
          user.messages = messages;
          chatController.onlineUsers.add(user);
          dbService.addChatUserMessages(user);
        }
      }
      chatController.update();
    });

    socket!.on('typing', (data) {
      ChatController chatController = Get.find();
      for (int i = 0; i < chatController.onlineUsers.length; i++) {
        if (chatController.onlineUsers[i].id == data["user_id"]) {
          chatController.onlineUsers[i].isTyping = data["status"] ?? false;
        }
      }
      chatController.update();
    });

    socket!.on('newUser', (userData) {
      print(userData);
      ChatController chatController = Get.find();
      User user = User.fromJson(userData);
      if (user.id != chatController.user.id) {
        var messages = dbService.getChatUserMessages(user.id!);
        user.messages = messages;
        int index = chatController.onlineUsers
            .indexWhere((element) => element.id == user.id);
        if (index != -1) {
          chatController.onlineUsers[index].isOnline = true;
        } else {
          chatController.onlineUsers.add(user);
          dbService.addChatUserMessages(user);
        }
      }
      chatController.update();
    });

    socket!.on('userDisconnect', (userId) {
      print("$userId disconnected");
      ChatController chatController = Get.find();
      int index = chatController.onlineUsers
          .indexWhere((element) => element.id == userId);
      if (index != -1) {
        chatController.onlineUsers[index].isOnline = false;
      }
      chatController.update();
    });
  }

  void sendReadMessage(Message message) {
    socket!.emit("messageRead", {
      "message_id": message.id,
      "sender_id": message.senderId,
      "receiver_id": message.receiverId,
    });
  }

  void sendTypingStatus(String userId, String receiverId, bool status) {
    socket!.emit("typing", {
      "user_id": userId,
      "receiver_id": receiverId,
      "status": status,
    });
  }

  void sendMessage(Message message) {
    socket!.emit(
      'newMessage',
      message.toJson(),
    );
  }
}
