import 'dart:async';
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

  String? chattingUserId;

  Timer? timer;

  TextEditingController messageTextEditingController =
      new TextEditingController();

  @override
  onInit() {
    messageTextEditingController.addListener(() {
      if (timer != null) {
        timer!.cancel();
      }
      socketService.sendTypingStatus(user.id!, chattingUserId!, true);
      timer = new Timer(Duration(seconds: 1), () {
        socketService.sendTypingStatus(user.id!, chattingUserId!, false);
      });
    });
    super.onInit();
  }

  connectToSocket() {
    if (connectFormKey.currentState!.validate()) {
      socketService.connectSocket(user);
    }
  }

  addUserId(String userId) {
    user.id = userId;
  }

  sendMessage(String receiverId) {
    if (messageTextEditingController.text.isNotEmpty) {
      Message messageModel = new Message(
          id: uuid.v4(),
          message: messageTextEditingController.text,
          messageType: 0,
          receiverId: receiverId,
          senderId: user.id,
          createdAt: DateTime.now());
      socketService.sendMessage(messageModel);
      int index = onlineUsers.indexWhere((element) => element.id == receiverId);
      if (index != -1) {
        onlineUsers[index].messages.insert(0, messageModel);
        dbService.addChatUserMessages(onlineUsers[index]);
        update();
      }
      messageTextEditingController.clear();
    }
  }

  sendImageMessage(String receiverId, bool isGallery) async {
    Uint8List? base64 = await getImage(isGallery);
    if (base64 != null) {
      Message messageModel = new Message(
          id: uuid.v4(),
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
        dbService.addChatUserMessages(onlineUsers[index]);
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
