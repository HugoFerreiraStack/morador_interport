import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'abertura_chamado_controller.dart';

class AberturaChamadoPage extends StatefulWidget {
  final String title;
  const AberturaChamadoPage({Key key, this.title = "AberturaChamado"})
      : super(key: key);

  @override
  _AberturaChamadoPageState createState() => _AberturaChamadoPageState();
}

class _AberturaChamadoPageState
    extends ModularState<AberturaChamadoPage, AberturaChamadoController> {
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
