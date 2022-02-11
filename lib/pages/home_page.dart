//Packages
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

//Pages
import '../pages/users_page.dart';
import '../pages/chats_page.dart';
import '../pages/qr_page.dart';
import '../pages/todo_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late FirebaseMessaging messaging;
  int _currentPage = 0;

  final List<Widget> _pages = [
    UsersPage(),
    ChatsPage(),
    QrPage(),
    ToDoPage(),
  ];

  void fcmController() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fcmController();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(155, 217, 191, 1.0),
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(
            () {
              _currentPage = _index;
            },
          );
        },
        items: [
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(
              Icons.supervisor_account_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.message,
            ),
          ),
          BottomNavigationBarItem(
            label: "QR Code",
            icon: Icon(
              Icons.qr_code_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: "ToDo",
            icon: Icon(
              Icons.sticky_note_2_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
