import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserData {
  static final UserData _userData = UserData._internal();

  int? id;
  late String deviceId;
  Map? data;
  late DateTime updatedAt;

  factory UserData() {
    return _userData;
  }

  Future<String> getDeviceID() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String salt = dotenv.env['SALT']!;
    var deviceId = "";
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        var bytes = utf8.encode(build.androidId! + salt);
        deviceId = sha1.convert(bytes).toString(); // Hashed for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        var bytes = utf8.encode(data.identifierForVendor! + salt);
        deviceId = sha1.convert(bytes).toString(); // Hashed for iOS
      }
      const bool isProduction = bool.fromEnvironment('dart.vm.product');
      if (!isProduction) deviceId += "_dev";
    } on PlatformException {
      print('Failed to get platform version');
    }
    return deviceId;
  }

  Future init() async {
    deviceId = await getDeviceID();
    id = await apiProvider.loginUser(deviceId);
    data = (await apiProvider.getUser(id));
    updatedAt = DateTime.now();
  }

  Future update() async {
    data = (await apiProvider.getUser(id));
    updatedAt = DateTime.now();
  }

  UserData._internal();
}

final userData = UserData();
