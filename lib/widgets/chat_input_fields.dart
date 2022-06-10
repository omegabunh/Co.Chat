// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ChatTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String message;
  final Function() send;
  final Function() imageSend;
  final double size;

  const ChatTextFormField({
    required this.onSaved,
    required this.regEx,
    required this.message,
    required this.send,
    required this.imageSend,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : message;
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        fillColor: const Color.fromRGBO(64, 127, 104, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: SizedBox(
          height: size,
          width: size,
          child: Transform.scale(
            scale: 0.7,
            child: FloatingActionButton(
              heroTag: "sendImage",
              backgroundColor: const Color.fromRGBO(64, 200, 104, 1.0),
              onPressed: imageSend,
              child: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
        suffixIcon: SizedBox(
          height: size,
          width: size,
          child: Transform.scale(
            scale: 0.7,
            child: FloatingActionButton(
              heroTag: "sendMessage",
              backgroundColor: const Color.fromRGBO(64, 200, 104, 1.0),
              onPressed: send,
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
