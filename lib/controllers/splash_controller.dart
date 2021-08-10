import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/screens/connect_screen.dart';
import 'package:flutter_private_chat/services/db_services.dart';
import 'package:flutter_private_chat/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:device_info/device_info.dart';

class SplashController extends GetxController {
  DBService dbService = Get.find();
  SocketService socketService = Get.find();

  @override
  onInit() {
    getDeviceInformations();
    super.onInit();
  }

  getDeviceInformations() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    ChatController chatController = Get.find();
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      chatController.addUserId(androidInfo.androidId);
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      chatController.addUserId(iosInfo.identifierForVendor);
    }
  }

  @override
  void onReady() {
    User? dbUser = dbService.getUser();
    if (dbUser != null) {
      socketService.connectSocket(dbUser);
    } else {
      Get.to(() => ConnectScreen());
    }
    super.onReady();
  }
}
