//Packages
import 'package:Co.Chat/pages/users_page.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_image.dart';
import '../widgets/top_bar.dart';

//Providers
import '../providers/authentication_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

  late String uid;
  late String email;
  late String name;
  late String profileImage;

  String? _name;
  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    uid = _auth.user.uid;
    name = _auth.user.name;
    email = _auth.user.email;
    profileImage = _auth.user.imageURL;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Edit profile',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _profileImageField(),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            _imageEditButton(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerForm(),
            _nameEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (_file) {
            setState(
              () {
                _profileImage = _file;
              },
            );
          },
        );
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedUserImageFile(
            key: UniqueKey(),
            image: profileImage,
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: CustomTextFormField(
          onSaved: (_value) {
            setState(() {
              _name = _value;
            });
          },
          regEx: r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{2,6}$',
          hintText: name,
          obscureText: false,
          message: '2~6자 이내의 이름을 입력해주십시요.',
        ),
      ),
    );
  }

  Widget _imageEditButton() {
    return ArgonButton(
      height: _deviceHeight * 0.035,
      width: _deviceWidth * 0.15,
      roundLoadingShape: true,
      onTap: (startLoading, stopLoading, btnState) async {
        if (btnState == ButtonState.Idle) {
          startLoading();
          if (_profileImage != null) {
            String? _imageURL =
                await _cloudStorage.saveUserImageToStorage(uid, _profileImage!);
            await _db.updateUser(uid, email, _name!, _imageURL!);
            await _auth.logout();
          }
        } else {
          stopLoading();
        }
      },
      child: const Icon(
        Icons.camera_alt,
        color: Colors.white,
      ),
      loader: Container(
        padding: const EdgeInsets.all(10),
        child: const SpinKitRotatingCircle(
          color: Colors.white,
        ),
      ),
      borderRadius: 5.0,
      color: const Color.fromRGBO(64, 200, 104, 1.0),
    );
  }

  Widget _nameEditButton() {
    return ArgonButton(
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.35,
      roundLoadingShape: true,
      onTap: (startLoading, stopLoading, btnState) async {
        if (btnState == ButtonState.Idle) {
          startLoading();
          if (_registerFormKey.currentState!.validate()) {
            _registerFormKey.currentState!.save();
            await _db.updateUser(uid, email, _name!, profileImage);
            await _auth.logout();
          }
        } else {
          stopLoading();
        }
      },
      child: const Text(
        "이름 변경",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      loader: Container(
        padding: const EdgeInsets.all(10),
        child: const SpinKitRotatingCircle(
          color: Colors.white,
        ),
      ),
      borderRadius: 5.0,
      color: const Color.fromRGBO(64, 200, 104, 1.0),
    );
  }
}
