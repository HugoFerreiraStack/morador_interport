import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<bool> getUserPermission(
  BuildContext context,
  String message,
) async {
  Widget dialog = AlertDialog(
    title: Text('Aviso'),
    content: Text(message),
    actions: [
      FlatButton(
        onPressed: () {
          return Modular.to.pop(true);
        },
        child: Text('Sim'),
      ),
      FlatButton(
        onPressed: () {
          return Modular.to.pop(false);
        },
        child: Text('Não'),
        color: Colors.black,
      ),
    ],
  );

  bool permission = await showDialog(
    context: context,
    child: dialog,
  );

  return permission ?? false;
}
