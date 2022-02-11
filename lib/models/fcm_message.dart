import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

const String _serverKey = "yourServerKey";

void sendNotificationToDriver(
    String token, context, String sender, String text) async {
  if (token == null) {
    print('Unable to send FCM message, no token exists.');
    return;
  }

  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$_serverKey',
      },
      body: constructFCMPayload(token, sender, text),
    );
    print('FCM request for device sent!');
  } catch (e) {
    print(e);
  }
}

String constructFCMPayload(String token, String sender, String text) {
  var res = jsonEncode({
    'token': token,
    'notification': {"body": text, "title": sender},
    "priority": "high",
    'data': {
      "click_action": "FLUTTER_NOTIFIATION_CLICK",
      "id": "1",
      "status": "done",
    },
    'to': token,
  });

  print(res.toString());
  return res;
}
