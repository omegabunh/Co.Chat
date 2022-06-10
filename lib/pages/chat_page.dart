//Packages
// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/chat_input_fields.dart';

//Modles
import '../models/chat.dart';
import '../models/chat_message.dart';
//import '../models/fcm_message.dart';

//Porviders
import '../providers/authentication_provider.dart';
import '../providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  // ignore: use_key_in_widget_constructors
  const ChatPage({required this.chat});

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatPageProvider>(
            create: (_) => ChatPageProvider(
                widget.chat.uid, _auth, _messagesListViewController),
          )
        ],
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    widget.chat.title(),
                    fontSize: 20,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _pageProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: Icon(
                        Icons.adaptive.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _pageProvider.goBack();
                      },
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return CupertinoScrollbar(
          thickness: 6.0,
          thicknessWhileDragging: 10.0,
          radius: const Radius.circular(34.0),
          radiusWhileDragging: Radius.zero,
          child: SizedBox(
            height: _deviceHeight * 0.74,
            child: ListView.builder(
              shrinkWrap: true,
              controller: _messagesListViewController,
              itemCount: _pageProvider.messages!.length,
              itemBuilder: (BuildContext _context, int _index) {
                ChatMessage _message = _pageProvider.messages![_index];
                bool _isOwnMessage = _message.senderID == _auth.user.uid;
                return CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * 0.80,
                  message: _message,
                  isOwnMessage: _isOwnMessage,
                  sender: widget.chat.members
                      .where((_m) => _m.uid == _message.senderID)
                      .first,
                );
              },
            ),
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "만나서 반가워요!",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }

  Widget _sendMessageForm() {
    late String text;
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      child: Form(
        key: _messageFormState,
        child: ChatTextFormField(
          size: _deviceHeight * 0.04,
          onSaved: (_value) {
            text = _pageProvider.message = _value;
          },
          regEx: r"^(?!\s*$).+",
          message: '',
          send: () {
            if (_messageFormState.currentState!.validate()) {
              _messageFormState.currentState!.save();
              _pageProvider.sendTextMessage();
              // fcm 송신
              // sendNotificationToDriver(
              //     'token',
              //     context,
              //     _auth.user.name,
              //     text);
              _messageFormState.currentState!.reset();
            }
          },
          imageSend: () {
            _pageProvider.sendImageMessage();
          },
        ),
      ),
    );
  }
}
