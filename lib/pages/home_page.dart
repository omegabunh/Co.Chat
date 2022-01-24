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
  PageController pageController = PageController();
  final List<Widget> _pages = [
    UsersPage(),
    ChatsPage(),
    QrPage(),
  ];
  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: _onItemTapped,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            label: "Users",
            icon: Icon(
              Icons.person,
            ),
          ),
          const BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat_bubble_rounded,
            ),
          ),
          const BottomNavigationBarItem(
            label: "QR Code",
            icon: Icon(
              Icons.qr_code_rounded,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
