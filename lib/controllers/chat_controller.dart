import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_private_chat/models/message.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/services/db_services.dart';
import 'package:flutter_private_chat/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
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

  FocusNode focusNode = new FocusNode();

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
        onlineUsers[index].messages.insert(0, messageModel);
        dbService.addChatUser(onlineUsers[index]);
        update();
      }
      messageTextEditingController.clear();
    }
  }

  sendImageMessage(String receiverId, bool isGallery) async {
    Uint8List? base64 = await getImage(isGallery);
    if (base64 != null) {
      Message messageModel = new Message(
          image: base64,
          message: "",
          messageType: 1,
          receiverId: receiverId,
          senderId: user.id,
          createdAt: DateTime.now());
      socketService.sendMessage(messageModel);
      // messageModel.message = base64Decode(base64);
      int index = onlineUsers.indexWhere((element) => element.id == receiverId);
      if (index != -1) {
        onlineUsers[index].messages.insert(0, messageModel);
        dbService.addChatUser(onlineUsers[index]);
        update();
      }
      messageTextEditingController.clear();
    }
  }

  getImage(bool isGallery) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: isGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 20,
      // maxHeight: 100,
      // maxWidth: 100,
    );
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      // String base64 = base64Encode(bytes);
      return bytes;
    }
    return null;

    // // Capture a photo
    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    // // Pick a video
    // final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
    // // Capture a video
    // final XFile? photo = await _picker.pickVideo(source: ImageSource.camera);
    // // Pick multiple images
    // final List<XFile>? images = await _picker.pickMultiImage();
  }
}
