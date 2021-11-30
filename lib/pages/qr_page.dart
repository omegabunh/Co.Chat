//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:timer_builder/timer_builder.dart';
import 'package:date_format/date_format.dart';

//Providers
import '../providers/authentication_provider.dart';

class QrPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrPageState();
  }
}

class _QrPageState extends State<QrPage> {
  //qr code time
  String now = formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]);

  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      //backgroundColor: Colors.blue,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImage(
                    //data: "박성우 $now",
                    data: "test",
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                    gapless: false,
                  ),
                  SizedBox(height: 40),
                ],
              ),
              TimerBuilder.periodic(
                const Duration(seconds: 1),
                builder: (context) {
                  return Text(
                    formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]),
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
