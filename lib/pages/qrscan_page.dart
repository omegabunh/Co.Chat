import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan/scan.dart';

import '../pages/qr_page.dart';

import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

class QRscanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QRscanPageState();
  }
}

class _QRscanPageState extends State<QRscanPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late List<String> word;
  late String name;
  late String uid;
  late String qrTime;

  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

  String _platformVersion = 'Unknown';
  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    ScanController controller = ScanController();
    String qrcode = 'Unknown';

    return Container(
      width: _deviceWidth,
      height: _deviceHeight,
      child: ScanView(
        controller: controller,
        scanAreaScale: 0.7,
        scanLineColor: Colors.green.shade400,
        onCapture: (data) async {
          word = data.split(',');
          uid = word[0].trim();
          name = word[1].trim();
          qrTime = word[2].trim();
          if (data != null) {
            await _db.addWorkRecord(uid, qrTime, name);
          }
          Fluttertoast.showToast(
            msg: "uid: $uid\nname: $name\nqrTime: $qrTime",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 10,
          );
        },
      ),
    );
  }
}
