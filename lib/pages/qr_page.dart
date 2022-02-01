//Packages
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter_countdown_timer/index.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:date_format/date_format.dart';

//Providers
import '../providers/authentication_provider.dart';

//Widgets
import '../widgets/top_bar.dart';

//Pages
import '../pages/qrscan_page.dart';

class QrPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrPageState();
  }
}

class _QrPageState extends State<QrPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late String uid;
  late String name;
  late String profileImage;

  late AuthenticationProvider _auth;

  bool _visibility = true;

  //qr code time
  String now = formatDate(DateTime.now(),
      [yyyy, '년 ', mm, '월 ', dd, '일 ', am, ' ', hh, '시 ', nn, '분 ', ss, '초'],
      locale: const KoreanDateLocale());

  int _endTime = DateTime.now().millisecondsSinceEpoch +
      const Duration(seconds: 15).inMilliseconds;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
    uid = _auth.user.uid;
    name = _auth.user.name;
    profileImage = _auth.user.imageURL;
    return Builder(
      builder: (BuildContext _context) {
        if (Platform.isIOS) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.02,
            ),
            height: _deviceHeight,
            width: _deviceWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(
                  "QR Code",
                  primaryAction: CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            color: Colors.transparent,
                            child: CupertinoActionSheet(
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('로그아웃'),
                                  onPressed: () {
                                    _auth.logout();
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('QR Scanner'),
                                  onPressed: () {
                                    Navigator.push(
                                      _context,
                                      MaterialPageRoute(
                                        builder: (_context) => QRscanPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                isDefaultAction: true,
                                child: const Text('닫기'),
                                onPressed: () {
                                  Navigator.pop(context, 1);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
                ProfileImage(),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                QrCodeImage(),
                const SizedBox(height: 40),
                CountdownTimer(
                  endTime: _endTime,
                  widgetBuilder: (_, CurrentRemainingTime? time) {
                    if (time == null) {
                      return QrRefreshButton();
                    }
                    return SizedBox(
                      child: Text(
                        '${time.sec}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                  onEnd: _hide,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'QR Code',
                primaryAction: PopupMenuButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onSelected: (result) {
                    if (result == 0) {
                      _auth.logout();
                    } else if (result == 1) {
                      Navigator.push(
                        _context,
                        MaterialPageRoute(
                          builder: (_context) => QRscanPage(),
                        ),
                      );
                    } else if (result == 2) {}
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: Text('로그아웃'),
                      value: 0,
                    ),
                    const PopupMenuItem(
                      child: Text('QRscan'),
                      value: 1,
                    ),
                  ],
                ),
              ),
              ProfileImage(),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              QrCodeImage(),
              const SizedBox(height: 40),
              CountdownTimer(
                endTime: _endTime,
                widgetBuilder: (_, CurrentRemainingTime? time) {
                  if (time == null) {
                    return QrRefreshButton();
                  }
                  return SizedBox(
                    child: Text(
                      '${time.sec}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
                onEnd: _hide,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget ProfileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(profileImage),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        color: Colors.black,
      ),
    );
  }

  Widget QrCodeImage() {
    return Visibility(
      visible: _visibility,
      child: QrImage(
        data: "$uid,$name,$now",
        version: QrVersions.auto,
        size: 200,
        backgroundColor: Colors.white,
        gapless: false,
      ),
    );
  }

  Widget QrRefreshButton() {
    return FloatingActionButton(
      heroTag: "sendImage",
      backgroundColor: const Color.fromRGBO(64, 200, 104, 1.0),
      onPressed: updateUI,
      child: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    );
  }

  void updateUI() {
    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch +
          const Duration(seconds: 15).inMilliseconds;
      now = formatDate(
          DateTime.now(),
          [
            yyyy,
            '년 ',
            mm,
            '월 ',
            dd,
            '일 ',
            am,
            ' ',
            hh,
            '시 ',
            nn,
            '분 ',
            ss,
            '초'
          ],
          locale: const KoreanDateLocale());
      _show();
    });
  }

  void _show() {
    setState(() {
      _visibility = true;
    });
  }

  void _hide() {
    setState(() {
      _visibility = false;
    });
  }
}
