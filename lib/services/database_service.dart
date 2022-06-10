//Packages
// ignore_for_file: constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

//Models
import '../models/chat_message.dart';
import '../models/todo.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";
const String WORKRECORD_COLLECTION = "WorkRecords";
const String TODO_COLLECTION = "Todos";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ignore: empty_constructor_bodies
  DatabaseService() {}

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          "email": _email,
          "image": _imageURL,
          "last_active": DateTime.now().toUtc(),
          "name": _name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          "email": _email,
          "image": _imageURL,
          "last_active": DateTime.now().toUtc(),
          "name": _name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _db.collection(USER_COLLECTION);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatID, ChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatID)
          .collection(MESSAGES_COLLECTION)
          .add(
            _message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> addWorkRecord(
    String _uid,
    DateTime _qrTime,
    String _name,
  ) async {
    try {
      await _db
          .collection(WORKRECORD_COLLECTION)
          .doc(_uid)
          .collection("commuteTime")
          .add(
        {
          "name": _name,
          "time": DateTime.now().toUtc(),
          "qrTime": _qrTime,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update(
        {
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat =
          await _db.collection(CHAT_COLLECTION).add(_data);
      return _chat;
    } catch (e) {
      print(e);
    }
  }

  Future<void> addToDo(String _uid, String _name, Todo data) async {
    try {
      await _db.collection(TODO_COLLECTION).doc(_uid).collection('todo').add(
        {
          "name": _name,
          "ToDo": data.text,
          "isDone": data.isDone,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteToDo(
      String _uid, String _name, DocumentSnapshot doc) async {
    try {
      await _db
          .collection(TODO_COLLECTION)
          .doc(_uid)
          .collection('todo')
          .doc(doc.id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkToDo(
      String _uid, String _name, DocumentSnapshot doc) async {
    try {
      await _db
          .collection(TODO_COLLECTION)
          .doc(_uid)
          .collection('todo')
          .doc(doc.id)
          .update(
        {
          "isDone": !doc["isDone"],
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
