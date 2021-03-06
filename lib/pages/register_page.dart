//Packages
import 'dart:io';

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
import '../widgets/rounded_image.dart';

//Providers
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

  String? _email;
  String? _password;
  String? _name;
  PlatformFile? _profileImage;
  String? _companyCode;
  String companyCode = '123456';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight,
        width: _deviceWidth,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * 0.1,
            ),
            _registerButton(),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
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
            image: File(_profileImage!.path),
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedInImageFile(
            key: UniqueKey(),
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regEx: r'^[???-???|???-???|???-???0-9]{2,6}$',
              hintText: "Name",
              obscureText: false,
              message: '2~6??? ????????? ????????? ?????????????????????.',
              type: TextInputType.text,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
              message: '????????? ????????? ?????????????????????.',
              type: TextInputType.emailAddress,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regEx: r".{8,}",
              hintText: "Password",
              obscureText: true,
              message: '???????????? 8?????? ?????? ?????????????????????.',
              type: TextInputType.visiblePassword,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _companyCode = _value;
                });
              },
              regEx: r".{6,}",
              hintText: "CompanyCode",
              obscureText: false,
              message: '6????????? ??????????????? ?????????????????????.',
              type: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return ArgonButton(
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      roundLoadingShape: true,
      onTap: (startLoading, stopLoading, btnState) async {
        if (btnState == ButtonState.Idle) {
          if (_registerFormKey.currentState!.validate() &&
              _profileImage != null) {
            _registerFormKey.currentState!.save();
            if (_companyCode == companyCode) {
              startLoading();
              String? _uid = await _auth.registerUserUsingEmailAndPassword(
                  _email!, _password!);
              String? _imageURL = await _cloudStorage.saveUserImageToStorage(
                  _uid!, _profileImage!);
              await _db.createUser(_uid, _email!, _name!, _imageURL!);
              await _auth.logout();
              await _auth.loginUsingEmailAndPassword(_email!, _password!);
            }
          }
        } else {
          stopLoading();
        }
      },
      child: const Text(
        "????????????",
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
