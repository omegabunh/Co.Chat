//Packages
import 'package:flutter/material.dart';

//Pages
import '../pages/users_page.dart';
import '../pages/chats_page.dart';
import '../pages/qr_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    UsersPage(),
    ChatsPage(),
    QrPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            label: "Users",
            icon: Icon(
              Icons.supervisor_account_sharp,
            ),
          ),
          const BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat_bubble_sharp,
            ),
          ),
          const BottomNavigationBarItem(
            label: "QR Code",
            icon: Icon(
              Icons.qr_code_sharp,
            ),
          ),
        ],
      ),
    );
  }
}
