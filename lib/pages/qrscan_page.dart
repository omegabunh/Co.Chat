// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, unused_field, prefer_final_fields

import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan/scan.dart';
import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

class QRscanPage extends StatelessWidget {
  late List<String> word;
  late String name;
  late String uid;
  late DateTime qrTime;
  late String strTime;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

  final player = AudioCache();

  String _platformVersion = 'Unknown';
  String qrcode = 'Unknown';

  ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            ScanView(
              controller: controller,
              scanAreaScale: 0.7,
              scanLineColor: Colors.green.shade400,
              onCapture: (data) async {
                word = data.split(',');
                uid = word[0].trim();
                name = word[1].trim();
                strTime = word[2].trim();
                qrTime = DateTime.parse(strTime);
                if (DateTime.now().difference(qrTime).inSeconds <= 15) {
                  await _db.addWorkRecord(uid, qrTime, name);
                  final player = AudioCache();
                  player.play('voice.mp3');
                  Fluttertoast.showToast(
                    msg: "uid: $uid\nname: $name\nqrTime: $qrTime",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 10,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "QR Code를 재발급해주세요.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 10,
                  );
                }
                Future.delayed(
                  const Duration(milliseconds: 3000),
                  () {
                    controller.resume();
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("손전등"),
                  onPressed: () {
                    controller.toggleTorchMode();
                  },
                ),
                ElevatedButton(
                  child: const Text("정지"),
                  onPressed: () {
                    controller.pause();
                  },
                ),
                ElevatedButton(
                  child: const Text("시작"),
                  onPressed: () {
                    controller.resume();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
