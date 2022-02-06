//Packages
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Models
import '../models/todo.dart';

//Providers
import '../providers/authentication_provider.dart';

//Services
import '../services/navigation_service.dart';
import '../services/database_service.dart';

//Widgets
import '../widgets/top_bar.dart';

class ToDoPage extends StatefulWidget {
  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late DatabaseService _db;
  late String uid;
  late String name;
  late AuthenticationProvider _auth;

  final items = <Todo>[];
  final _loginFormKey = GlobalKey<FormState>();

  String? _text;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _db = GetIt.instance.get<DatabaseService>();
    _auth = Provider.of<AuthenticationProvider>(context);
    uid = _auth.user.uid;
    name = _auth.user.name;

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            children: [
              TopBar(
                'ToDo',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _auth.logout();
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Todos")
                    .doc(uid)
                    .collection(name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  final documents = snapshot.data!.docs;
                  return Expanded(
                    child: CupertinoScrollbar(
                      thickness: 6.0,
                      thicknessWhileDragging: 10.0,
                      radius: const Radius.circular(34.0),
                      radiusWhileDragging: Radius.zero,
                      child: ListView(
                        children:
                            documents.map((doc) => _toDoListView(doc)).toList(),
                      ),
                    ),
                  );
                },
              ),
              Container(
                alignment: const Alignment(0.95, 0.0),
                child: FloatingActionButton(
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('ToDo 추가'),
                        content: Card(
                          color: Colors.transparent,
                          elevation: 0.0,
                          child: Column(
                            children: [
                              CupertinoTextField(
                                onChanged: (String value) {
                                  _text = value;
                                },
                                style: const TextStyle(
                                    color: CupertinoColors.label),
                              ),
                            ],
                          ),
                        ),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: const Text('취소'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('저장'),
                            onPressed: () {
                              setState(
                                () {
                                  _db.addToDo(
                                    uid,
                                    name,
                                    Todo(_text!),
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight,
        width: _deviceWidth,
        child: Column(
          children: [
            TopBar(
              'ToDo',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Todos")
                  .doc(uid)
                  .collection(name)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator.adaptive();
                }
                final documents = snapshot.data!.docs;
                return Expanded(
                  child: ListView(
                    children:
                        documents.map((doc) => _toDoListView(doc)).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("ToDo 추가"),
                content: TextField(
                  onChanged: (String value) {
                    _text = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          _db.addToDo(
                            uid,
                            name,
                            Todo(_text!),
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("저장"),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _toDoListView(DocumentSnapshot doc) {
    final todo = Todo(doc['ToDo'], isDone: doc['isDone']);

    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (value) {
          setState(() {
            todo.isDone = value!;
          });
        },
      ),
      onTap: () {
        _db.checkToDo(uid, name, doc);
      },
      title: Text(
        todo.text,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _db.deleteToDo(uid, name, doc);
        },
      ),
    );
  }
}
