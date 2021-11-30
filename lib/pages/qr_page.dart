//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class QrPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrPageState();
  }
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: Colors.blue,
    );
  }
}
