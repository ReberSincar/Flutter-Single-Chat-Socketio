import 'dart:convert';

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

  addChatUser(User chatUser) async {
    String json = jsonEncode(chatUser.toJson());
    await storage.write('user_${chatUser.id}', json);
  }

  User? getChatUser(String userId) {
    var user = storage.read('user_$userId');
    if (user != null) {
      return User.fromJson(json.decode(user));
    }
    return null;
  }
}
