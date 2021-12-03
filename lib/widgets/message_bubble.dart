import 'package:flutter/material.dart';

//Packages
import 'package:timeago/timeago.dart' as timeago;

//Models
import '../models/chat_message.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  TextMessageBubble(
      {required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    List<Color> _colorScheme = isOwnMessage
        ? [
            Color.fromRGBO(204, 255, 204, 1.0),
            Color.fromRGBO(204, 255, 204, 1.0),
          ]
        : [
            Color.fromRGBO(153, 255, 153, 1.0),
            Color.fromRGBO(153, 255, 153, 1.0),
          ];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Text(
            timeago.format(message.sentTime, locale: 'ko'),
            style: TextStyle(
              fontSize: 10,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  ImageMessageBubble(
      {required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            Color.fromRGBO(204, 255, 204, 1.0),
            Color.fromRGBO(204, 255, 204, 1.0),
          ]
        : [
            Color.fromRGBO(153, 255, 153, 1.0),
            Color.fromRGBO(153, 255, 153, 1.0),
          ];
    DecorationImage _image = DecorationImage(
        image: NetworkImage(message.content), fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            timeago.format(message.sentTime, locale: 'ko'),
            style: TextStyle(
              fontSize: 10,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
