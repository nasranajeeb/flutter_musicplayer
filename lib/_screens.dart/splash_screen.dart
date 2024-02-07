import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:Zylae/_screens.dart/home.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    requestPermision();
    super.initState();
  }

  void requestPermision() async {
    int version = await checkAndroidVersion();
    if (version >= 32) {
      await checkPermission13();
    } else {
      await checkPermission12();
    }
  }

  checkPermission12() async {
    var p = await Permission.storage.request();
    if (p.isGranted) {
      // ignore: use_build_context_synchronously
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()));
      });
    }
  }

  checkPermission13() async {
    final per = await [Permission.audio, Permission.photos].request();

    if (per.values.every((status) => status == PermissionStatus.granted)) {
      // ignore: use_build_context_synchronously
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()));
      });
    }
  }

  Future<int> checkAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    int androidVersion = androidInfo.version.sdkInt;
    // ignore: avoid_print
    print('Android Version: $androidVersion');
    return androidVersion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 27, 8, 39),
        body: Image.asset("asset/splash.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: const Alignment(0.95, 0.70)));
  }
}
