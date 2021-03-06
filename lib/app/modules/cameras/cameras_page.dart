import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'cameras_controller.dart';

class CamerasPage extends StatefulWidget {
  final String title;
  const CamerasPage({Key key, this.title = "Cameras"}) : super(key: key);

  @override
  _CamerasPageState createState() => _CamerasPageState();
}

class _CamerasPageState extends ModularState<CamerasPage, CamerasController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
