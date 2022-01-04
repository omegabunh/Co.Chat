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
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isOwnMessage
                ? Color.fromRGBO(204, 255, 204, 1.0)
                : Color.fromRGBO(153, 255, 153, 1.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15.0, top: 10, bottom: 10),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 5.0,
                child: Row(
                  children: [
                    Text(
                      timeago.format(message.sentTime, locale: 'ko'),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
    DecorationImage _image = DecorationImage(
        image: NetworkImage(message.content), fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: isOwnMessage
        //     ? Color.fromRGBO(204, 255, 204, 1.0)
        //     : Color.fromRGBO(153, 255, 153, 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              height: height,
              width: width,
              child: Hero(
                tag: '$_image',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: _image,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      body: GestureDetector(
                        child: Center(
                          child: Hero(
                            tag: '$_image',
                            child: Image.network(
                              message.content,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              );
            },
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
