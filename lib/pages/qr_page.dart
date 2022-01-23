//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:timer_builder/timer_builder.dart';
import 'package:date_format/date_format.dart';

//Providers
import '../providers/authentication_provider.dart';

//Widgets
import '../widgets/top_bar.dart';

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

  //qr code time
  String now = formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]);

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
    return Builder(builder: (BuildContext _context) {
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
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
                onPressed: () {
                  _auth.logout();
                },
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
            QrImage(
              data: "$uid $now",
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              gapless: false,
            ),
            const SizedBox(height: 40),
            TimerBuilder.periodic(
              const Duration(seconds: 1),
              builder: (context) {
                return Text(
                  formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
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
}
