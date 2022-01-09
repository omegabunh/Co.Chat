//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';

//Modles
import '../models/chat.dart';
import '../models/chat_message.dart';

//Porviders
import '../providers/authentication_provider.dart';
import '../providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
              widget.chat.uid, _auth, _messagesListViewController),
        )
      ],
      child: _buildUI(),
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
              width: _deviceWidth * 0.97,
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
                        Icons.delete_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        _pageProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
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
      if (_pageProvider.messages!.length != 0) {
        return Container(
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
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(64, 127, 104, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: const EdgeInsets.all(10),
      child: Form(
        key: _messageFormState,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageMessageButton(),
              _messageTextField(),
              _sendMessageButton(),
            ]),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "",
        obscureText: false,
        message: '',
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        heroTag: "sendMessage",
        backgroundColor: Color.fromRGBO(64, 200, 104, 1.0),
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        heroTag: "sendImage",
        backgroundColor: Color.fromRGBO(64, 200, 104, 1.0),
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
        child: Icon(Icons.photo_camera_rounded),
      ),
    );
  }
}
