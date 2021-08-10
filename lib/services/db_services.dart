import 'dart:convert';

import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class DBService extends GetxService {
  GetStorage storage = new GetStorage();

  addUser(User user) async {
    await storage.write('user_id', json.encode(user.toJson()));
  }

  User? getUser() {
    var user = storage.read('user_id');
    if (user != null) {
      return User.fromJson(json.decode(storage.read('user_id')));
    }
    return null;
  }

  addChatUserMessages(User chatUser) async {
    await storage.write('messages_${chatUser.id}', chatUser.toJsonMessages());
  }

  getChatUserMessages(String userId) {
    var messages = storage.read('messages_$userId') ?? [];
    return messages.map((e) => Message.fromJson(e)).toList();
  }
}
