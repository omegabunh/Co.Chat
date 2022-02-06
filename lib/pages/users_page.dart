//Packages
import 'dart:io';

import 'package:Co.Chat/pages/profile_page.dart';
import 'package:Co.Chat/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

//Models
import '../models/chat_user.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;
  bool isDarkTheme = false;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(
            _auth,
          ),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Builder(
          builder: (BuildContext _context) {
            _pageProvider = _context.watch<UsersPageProvider>();
            if (Platform.isIOS) {
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
                      "Users",
                      primaryAction: CupertinoButton(
                        onPressed: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Material(
                                color: Colors.transparent,
                                child: CupertinoActionSheet(
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: const Text('로그아웃'),
                                      onPressed: () {
                                        _auth.logout();
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text('프로필 수정'),
                                      onPressed: () {
                                        Navigator.push(
                                          _context,
                                          MaterialPageRoute(
                                            builder: (_context) =>
                                                ProfilePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                  message: Wrap(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            '테마 변경',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          CupertinoSwitch(
                                            value: themeNotifier.isDark,
                                            onChanged: (value) {
                                              setState(() {
                                                themeNotifier.isDark = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  cancelButton: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    child: const Text('닫기'),
                                    onPressed: () {
                                      Navigator.pop(context, 1);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CustomTextField(
                      onEditingComplete: (_value) {
                        _pageProvider.getUsers(name: _value);
                        FocusScope.of(context).unfocus();
                      },
                      hintText: "검색...",
                      obscureText: false,
                      controller: _searchFieldTextEditingController,
                      icon: Icons.search,
                    ),
                    SizedBox(height: _deviceHeight * 0.005),
                    CustomProfileTile(
                      height: _deviceHeight * 0.10,
                      title: _auth.user.name,
                      imagePath: _auth.user.imageURL,
                      isActive: _auth.user.wasRecentlyActive(),
                    ),
                    SizedBox(height: _deviceHeight * 0.005),
                    _usersList(),
                    _createChatButton(),
                  ],
                ),
              );
            }
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
                    "Users",
                    primaryAction: PopupMenuButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onSelected: (result) {
                        if (result == 0) {
                          _auth.logout();
                        } else if (result == 1) {
                          Navigator.push(
                            _context,
                            MaterialPageRoute(
                              builder: (_context) => ProfilePage(),
                            ),
                          );
                        } else if (result == 2) {}
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        const PopupMenuItem(
                          child: Text('로그아웃'),
                          value: 0,
                        ),
                        const PopupMenuItem(
                          child: Text('프로필 수정'),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            title: const Text("테마 변경"),
                            trailing: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Switch.adaptive(
                                  value: themeNotifier.isDark,
                                  onChanged: (value) {
                                    setState(() {
                                      themeNotifier.isDark = value;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          value: 2,
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    onEditingComplete: (_value) {
                      _pageProvider.getUsers(name: _value);
                      FocusScope.of(context).unfocus();
                    },
                    hintText: "검색...",
                    obscureText: false,
                    controller: _searchFieldTextEditingController,
                    icon: Icons.search,
                  ),
                  SizedBox(height: _deviceHeight * 0.005),
                  CustomProfileTile(
                    height: _deviceHeight * 0.10,
                    title: _auth.user.name,
                    imagePath: _auth.user.imageURL,
                    isActive: _auth.user.wasRecentlyActive(),
                  ),
                  SizedBox(height: _deviceHeight * 0.005),
                  _usersList(),
                  _createChatButton(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _usersList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.isNotEmpty) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              if (_users[_index].name != _auth.user.name) {
                return CustomListViewTile(
                  height: _deviceHeight * 0.10,
                  title: _users[_index].name,
                  subtitle: "최근 활동: ${_users[_index].lastDayActive()}",
                  imagePath: _users[_index].imageURL,
                  isActive: _users[_index].wasRecentlyActive(),
                  isSelected: _pageProvider.selectedUsers.contains(
                    _users[_index],
                  ),
                  onTap: () {
                    _pageProvider.updateSelectedUsers(
                      _users[_index],
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return const Center(
            child: Text(
              "사용자를 찾을 수 없습니다.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _pageProvider.selectedUsers.length == 1 ? "1:1 채팅" : "그룹 채팅",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _pageProvider.createChat();
        },
      ),
    );
  }
}
